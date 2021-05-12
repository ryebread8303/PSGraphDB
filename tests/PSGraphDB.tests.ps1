#region setup
$here = $PSScriptRoot
$parent = Split-Path $here -Parent
$manifest = Import-PowerShellDataFile (join-path $parent "PSGraphDB.psd1")
$modulefiles = $manifest.FileList
#endregion setup


#region tests
Describe "Prerequisites" {
    Context "Module files" {
        foreach ($file in $modulefiles) {
            It "$file exists." {
                test-path (join-path $parent $file) | Should Be $true
            }
        }
    }
}
#endregion tests