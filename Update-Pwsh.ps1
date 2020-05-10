function Update-Pwsh {
    [CmdletBinding()]
    param()

    $eap = $ErrorActionPreference
    $ErrorActionPreference = "Stop"

    try {
        Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-powershell.ps1) } -UseMSI"
    } finally {
        $ErrorActionPreference = $eap
    }
}
