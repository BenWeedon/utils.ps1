using namespace System.Diagnostics

function Test-IsInJobObject {
    [CmdletBinding()]
    [OutputType([Boolean])]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [Process] $Process
    )

    process {
        $eap = $ErrorActionPreference
        $ErrorActionPreference = 'Stop'
        try {
            $functions = @'
            [DllImport("kernel32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
            public static extern Boolean IsProcessInJob(IntPtr ProcessHandle, IntPtr JobHandle, ref Boolean Result);
'@

            # We can't clear old types from the session, so ignore failures adding it.
            try { Add-Type -MemberDefinition $functions -Name Functions -Namespace Win32 } catch {}

            $isInJobObject = $false
            if ($null -ne $Process.Handle) {
                $result = [Win32.Functions]::IsProcessInJob($Process.Handle, 0, [ref] $isInJobObject)
                if (-not $result) {
                    Write-Error ([ComponentModel.Win32Exception]::new())
                }
                return $isInJobObject
            } else {
                return $false
            }
        } finally {
            $ErrorActionPreference = $eap
        }
    }
}
