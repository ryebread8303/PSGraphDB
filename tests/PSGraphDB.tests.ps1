using namespace System.Collections.Generic
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
        It "Should have a working constructor for signature (int id, string[] lables)." {
            $node = [GraphNode]::new(0,@("Device","Networking"))
            $node.ID | Should Be 0
            $node.Lables | Should Be @("Device","Networking")
        }
        It "Should have a working constructor for signature (int id, string[] lables, Dictionary<string,string> properties)" {
            $props = new-object System.Collections.Generic.Dictionary"[String, String]"
            $props.Add("name","boopsie")
            $props.Add("color","red")
            $node = [GraphNode]::new(0,@("Device","Networking"),$props)
            $node.ID | Should Be 0
            $node.Lables | Should Be @("Device","Networking")
            $node.Properties["name"] | Should Be "boopsie"
        }
    }
    Context "GraphRelation" {
        It "GraphRelation should be a type." {
            [GraphRelation] | Should Not Be $null
        }
        It "Should have a working constructor for signature (int id, GraphNode leftnode, string relationshiptype, GraphNode rightnode)" {
            $BobProps = New-Object System.Collections.Generic.Dictionary"[String,String]"
            $BobProps.Add("name","Bob")
            $AliceProps = New-Object System.Collections.Generic.Dictionary"[String,String]"
            $AliceProps.Add("name","Alice")
            $bob = [GraphNode]::new(0,"Person",$BobProps)
            $alice = [GraphNode]::new(1,"Person",$AliceProps)
            $relation = [GraphRelation]::new(0,$bob,"FRIENDS_WITH",$alice)
            $relation.LeftNode.Properties["name"] | Should Be "Bob"
            $relation.RightNode.Properties["name"] | Should Be "Alice"
            $relation.RelationshipType | Should Be "FRIENDS_WITH"
        }
    }

    Context "GraphDatabase" {
        It "GraphDatabase should be a type." {
            [GraphDatabase] | Should Not Be $null
        }
    }

}
#endregion tests