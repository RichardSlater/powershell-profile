$versionCache = "$($env:ProgramData)/versions/versionCache.xml"
$providerFiles = Get-ChildItem $PSScriptRoot -Filter 'Provider-*.ps1'
$providers = $providerFiles | Select-Object @{ Name='Provider'; Expression= { & $_.FullName } }
$versionData = $providers | Select-Object `
    @{ Name='Name'; Expression= { $_.Provider.Name } }, `
    @{ Name='ActiveVersion'; Expression={ & $_.Provider.ActiveVersion } }, `
    @{ Name='LatestVersion'; Expression={ & $_.Provider.LatestVersion } }
$versionData | Export-CliXml $versionCache
return $versionData
