#region setup
$here = $PSScriptRoot
$parent = Split-Path $here -Parent
$manifest = Import-PowerShellDataFile (join-path $parent "PSGraphDB.psd1")
$modulefiles = $manifest.FileList
import-module (join-path $parent "PSGraphDB.psd1")
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

Describe "Graph Classes" {
    Context "GraphNode" {
        It "GraphNode should be a type." {
            [GraphNode] | Should Not Be $null
        }
    }
    Context "GraphRelation" {
        It "GraphRelation should be a type." {
            [GraphRelation] | Should Not Be $null
        }
    }

    Context "GraphDatabase" {
        It "GraphDatabase should be a type." {
            [GraphDatabase] | Should Not Be $null
        }
    }

}
#endregion tests