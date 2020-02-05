function Edit-RunMru {
    <#
        .SYNOPSIS
        A script to edit the MRU for the Run dialog

        .DESCRIPTION
        Opens an editor (gvim) to edit the MRU list. The caller can reorder, add
        and remove entries from the list, and the updates will be saved back to
        the registry.

        .PARAMETER Force
        Save the edits without prompting the user for confirmation
    #>

    [CmdletBinding()]
    param(
        [switch]$Force
    )
    PROCESS {
        $eap = $ErrorActionPreference
        $ErrorActionPreference = "Stop"

        try {

            $mruRegistryKey = Get-Item HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU
            $mruList = $mruRegistryKey.GetValue("MRUList")
            $mruListArray = $mruList.ToCharArray()

            $tempFileContents = @"
# The following lines represent the item in the Run dialog MRU, in order.
# The format is "<key> <item>" where key is a single letter.
# Edit the below list to update the MRU, any reordering will be preserved.


"@
            foreach ($mruItemKey in $mruListArray) {
                $tempFileContents += "$mruItemKey $($mruRegistryKey.GetValue($mruItemKey))`n"
            }

            $tempFile = New-TemporaryFile
            try {
                Out-File -FilePath $tempFile.FullName -Encoding utf8 -InputObject $tempFileContents -NoNewline
                gvim $tempFile.FullName
                $tempFileContents = Get-Content $tempFile
            } finally {
                Remove-Item $tempFile
            }

            $newMruList = ""
            $newMruItems = @{}
            $tempFileContents = $tempFileContents | Where-Object { $_ -and -not $_.StartsWith("#") }
            foreach ($line in $tempFileContents) {
                if ($line -notmatch "^([a-z]) (.*\\1)$") {
                    Write-Error "Error parsing new MRU"
                }

                if ($newMruItems.ContainsKey($matches[1])) {
                    Write-Error "Duplicate item key specified"
                }

                $newMruList += $matches[1]
                $newMruItems[$matches[1]] = $matches[2]
            }

            if ($mruRegistryKey.GetValue("MRUList") -ne $mruList) {
                Write-Error "The MRU list has changed while editing, please try again"
            }

            $mruItemsToUpdate = $newMruItems.GetEnumerator() | Where-Object { $mruRegistryKey.GetValue($_.Name) -ne $_.Value }

            if (-not $Force) {
                Write-Host "The following changes will be made to the registry:"
                Write-Host "MRUList = $newMruList"
                foreach ($item in $mruItemsToUpdate) {
                    Write-Host "$($item.Name) = $($item.Value)"
                }

                $confirm = $Host.UI.PromptForChoice("Would you like to continue?" -f $numberToClean, $message, @("Yes", "No"), 1)
                if ($confirm -ne 0) {
                    Write-Error "Aborting"
                }
            }

            Set-ItemProperty -Path $mruRegistryKey.PSPath -Name "MRUList" -Value $newMruList
            foreach ($item in $mruItemsToUpdate) {
                Set-ItemProperty -Path $mruRegistryKey.PSPath -Name $item.Name -Value $item.Value
            }
        } finally {
            $ErrorActionPreference = $eap
        }
    }
}
