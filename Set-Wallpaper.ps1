function Set-Wallpaper {
    [CmdletBinding()]
    [OutputType([Void])]
    Param(
        [Parameter(Mandatory=$True, Position=0)]
        [String]$Path,
        [Parameter(Mandatory=$False, Position=1)]
        [ValidateSet("Tile", "Center", "Stretch", "Fill", "Fit", "Span", "NoChange")]
        [String]$Style = "Fill"
    )
    PROCESS {
        # Adapted from http://stackoverflow.com/questions/9440135/powershell-script-from-shortcut-to-change-desktop.
        Add-Type @"
            using System;
            using System.Runtime.InteropServices;
            using Microsoft.Win32;
            namespace Wallpaper
            {
                public enum Style : int
                {
                    Tile     = 0,
                    Center   = 1,
                    Stretch  = 2,
                    Fill     = 3,
                    Fit      = 4,
                    Span     = 5,
                    NoChange = 6
                }
                public class Setter {
                    public const int SetDesktopWallpaper = 20;
                    public const int UpdateIniFile = 0x01;
                    public const int SendWinIniChange = 0x02;
                    [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
                    private static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni);
                    public static void SetWallpaper(string path, Wallpaper.Style style) {
                        RegistryKey key = Registry.CurrentUser.OpenSubKey("Control Panel\\Desktop", true);
                        switch( style )
                        {
                        case Style.Stretch:
                            key.SetValue(@"WallpaperStyle", "2");
                            key.SetValue(@"TileWallpaper", "0");
                            break;
                        case Style.Center:
                            key.SetValue(@"WallpaperStyle", "0");
                            key.SetValue(@"TileWallpaper", "0");
                            break;
                        case Style.Tile:
                            key.SetValue(@"WallpaperStyle", "0");
                            key.SetValue(@"TileWallpaper", "1");
                            break;
                        case Style.Fill:
                            key.SetValue(@"WallpaperStyle", "10");
                            key.SetValue(@"TileWallpaper", "0");
                            break;
                        case Style.Fit:
                            key.SetValue(@"WallpaperStyle", "6");
                            key.SetValue(@"TileWallpaper", "0");
                            break;
                        case Style.Span:
                            key.SetValue(@"WallpaperStyle", "22");
                            key.SetValue(@"TileWallpaper", "0");
                            break;
                        case Style.NoChange:
                            break;
                        }
                        key.Close();
                        SystemParametersInfo(SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange);
                    }
                }
            }
"@
        [Wallpaper.Setter]::SetWallpaper((Convert-Path $Path), $Style)
    }
}
