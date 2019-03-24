function Watch-Command {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True, Position=0)]
        [ScriptBlock]$Command,
        [Parameter(Mandatory=$False, Position=1)]
        [Double]$Seconds = 2
    )
    PROCESS {
        while ($True) {
            Clear-Host
            & $Command | Out-String
            Start-Sleep -Seconds $Seconds
        }
    }
}
New-Alias watch Watch-Command
