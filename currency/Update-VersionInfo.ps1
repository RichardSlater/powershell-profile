function Update-VersionInfo () {
  $providerFiles = Get-ChildItem $PSScriptRoot -Filter 'Provider-*.ps1'
  $providers = $providerFiles | Select-Object @{ Name='Provider'; Expression= { & $_.FullName } }
  return $providers | Select-Object `
    @{ Name='Name'; Expression= { $_.Provider.Name } }, `
    @{ Name='ActiveVersion'; Expression={ & $_.Provider.ActiveVersion } }, `
    @{ Name='LatestVersion'; Expression={ & $_.Provider.LatestVersion } }
}

function Format-VersionTable () {
  param(
    [Parameter(
        Position=0,
        Mandatory=$true,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true)
    ]
    $Versions
  )
  begin {
    $versionCache = @()
  }
  process {
    foreach ($version in $Versions) {
      $versionCache = $versionCache + $version
    }
  }
  end {
    $maxLen = ($versionCache | Sort-Object { $_.Name.Length } | Select-Object -Last 1).Name.Length
    foreach ($version in $versionCache) {
      $padding = $(" " * (($maxLen - $version.Name.Length) + 2))
      Write-Host "$($version.Name): $padding" -ForegroundColor White -NoNewLine;
      if ($version.ActiveVersion -eq $version.LatestVersion) {
        Write-Host $version.ActiveVersion
      } else {
        Write-Host -ForegroundColor Red $version.ActiveVersion -NoNewLine
        Write-Host -ForegroundColor Green " ($($version.LatestVersion))"
      }
    }
  }
}

$versionCache = "$PSScriptRoot\versionCache.xml"
$cacheExists = Test-Path ($versionCache)
$lastWrite = Get-ChildItem $versionCache -ErrorAction SilentlyContinue | Select-Object -ExpandProperty LastWriteTime
$lastWriteWithinDay = $lastWrite -lt (Get-Date).AddDays(-1)
if (-Not $cacheExists -And $lastWriteWithinDay) {
  Update-VersionInfo | Export-CliXml $versionCache
}

Import-CliXml $versionCache | Format-VersionTable
