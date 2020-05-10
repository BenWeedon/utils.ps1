function Start-AdminPwsh {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromRemainingArguments)]
        $Arguments
    )

    $eap = $ErrorActionPreference
    $ErrorActionPreference = "Stop"

    try {
        $argList =  @("-WorkingDirectory $(Get-Location)")
        if ($Arguments.Count -gt 0) {
            $argList += " -Command $Arguments; Pause"
        }
        Start-Process -Verb RunAs pwsh -ArgumentList $argList
    } finally {
        $ErrorActionPreference = $eap
    }
}
New-Alias sudo Start-AdminPwsh
