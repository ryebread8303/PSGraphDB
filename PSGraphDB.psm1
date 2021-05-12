$ClassDefinitionFile = join-path $PSScriptRoot PSGraphDB-Classes
$ClassDefinitionText = get-content = $ClassDefinitionFile
add-type -TypeDefinition $ClassDefinitionText