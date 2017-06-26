# Module manifest for module "utils.psm1"
@{

# Script module or binary module file associated with this manifest
RootModule = "utils.psm1"

# Version number of this module.
ModuleVersion = "0.1"

# ID used to uniquely identify this module
GUID = "518dc353-f0af-42d6-925b-a65763ea74bf"

# Author of this module
Author = "Ben Weedon"

# Description of the functionality provided by this module
Description = "Some useful PowerShell utilities"

# TODO: Are these minimum versions correct?
# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = "5.0"

# Minimum version of the common language runtime (CLR) required by this module
CLRVersion = "4.0"

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = @(
    "Watch-Command.ps1",
    "Set-Wallpaper.ps1")

# Cmdlets to export from this module
CmdletsToExport = @(
    "Watch-Command",
    "Set-Wallpaper.ps1")

AliasesToExport = @(
    "watch")
}
