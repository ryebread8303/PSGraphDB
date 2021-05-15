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
        It "Should have a working constructor for signature (string[] lables)." {
            $node = [GraphNode]::new(@("Device","Networking"))
            $node.Lables | Should Be @("Device","Networking")
        }
        It "Should be able to add properties after the object is created" {
            $node = [GraphNode]::new("Device")
            $node.Properties.Add("name","widget")
            $node.Properties["name"] | Should Be "widget"
        }
        It "Should have a working constructor for signature (string[] lables, Dictionary<string,string> properties)" {
            $props = new-object System.Collections.Generic.Dictionary"[String, String]"
            $props.Add("name","boopsie")
            $props.Add("color","red")
            $node = [GraphNode]::new(@("Device","Networking"),$props)
            $node.Lables | Should Be @("Device","Networking")
            $node.Properties["name"] | Should Be "boopsie"
        }
    }
    Context "GraphRelation" {
        It "GraphRelation should be a type." {
            [GraphRelation] | Should Not Be $null
        }
        It "Should have a working constructor for signature (GraphNode leftnode, string relationshiptype, GraphNode rightnode)" {
            $BobProps = New-Object System.Collections.Generic.Dictionary"[String,String]"
            $BobProps.Add("name","Bob")
            $AliceProps = New-Object System.Collections.Generic.Dictionary"[String,String]"
            $AliceProps.Add("name","Alice")
            $bob = [GraphNode]::new("Person",$BobProps)
            $alice = [GraphNode]::new("Person",$AliceProps)
            $relation = [GraphRelation]::new($bob,"FRIENDS_WITH",$alice)
            $relation.LeftNode.Properties["name"] | Should Be "Bob"
            $relation.RightNode.Properties["name"] | Should Be "Alice"
            $relation.RelationshipType | Should Be "FRIENDS_WITH"
        }
    }

    Context "GraphDatabase" {
        It "GraphDatabase should be a type." {
            [GraphDatabase] | Should Not Be $null
        }
        $bob = [GraphNode]::new("Person")
        $alice = [GraphNode]::new("Person")
        $bob.Properties.Add("name","bob")
        $alice.Properties.Add("name","Alice")
        $alice.Properties.Add("hobby","trains")
        $database = new-object GraphDatabase
        $database.AddNode($bob)
        $database.AddNode($alice)

        It "Should return all nodes when starting query." {
            $database.V().count | Should Be 2
        }
        It "Should be able to filter nodes that contain a label." {
            $database.V().has("hobby").Properties["hobby"] | Should Be "trains"
        }
    }

}
#endregion tests