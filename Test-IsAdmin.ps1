function Test-IsAdmin {
    [CmdletBinding()]
    param()

    PROCESS {
        $eap = $ErrorActionPreference
        $ErrorActionPreference = "Stop"

        try {
            $principal = [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
            $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
        } finally {
            $ErrorActionPreference = $eap
        }
    }
}
