function Start-AdminPwsh {
    [CmdletBinding()]
    param()

    $eap = $ErrorActionPreference
    $ErrorActionPreference = "Stop"

    try {
        Start-Process -Verb RunAs pwsh
    } finally {
        $ErrorActionPreference = $eap
    }
}
New-Alias sudo Start-AdminPwsh
