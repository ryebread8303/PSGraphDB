$ClassDefinitionFile = join-path $PSScriptRoot PSGraphDB-Classes
$ClassDefinitionText = get-content $ClassDefinitionFile -Raw
add-type -TypeDefinition $ClassDefinitionText