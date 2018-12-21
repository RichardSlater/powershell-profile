$dataPath = "$($env:ProgramData)\versions\"
if (-Not (Test-Path $dataPath)) {
  New-Item -ItemType Directory -Path $dataPath | Out-Null
}
$versionCache = "$dataPath\versionCache.xml"

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

$updateVersionInfo = {
  function Update-VersionInfo () {
    $providerFiles = Get-ChildItem $PSScriptRoot -Filter 'Provider-*.ps1'
    $providers = $providerFiles | Select-Object @{ Name='Provider'; Expression= { & $_.FullName } }
    return $providers | Select-Object `
      @{ Name='Name'; Expression= { $_.Provider.Name } }, `
      @{ Name='ActiveVersion'; Expression={ & $_.Provider.ActiveVersion } }, `
      @{ Name='LatestVersion'; Expression={ & $_.Provider.LatestVersion } }
  }
  
  $versionCache = "$($env:ProgramData)/versions/versionCache.xml"
  $versionData = Update-VersionInfo
  $versionData | Export-CliXml $versionCache
  return $versionData
}

$versionData = $null
if (-Not (Test-Path ($versionCache))) {
  $versionData = & $updateVersionInfo
} else {
  $lastWrite = Get-ChildItem $versionCache -ErrorAction SilentlyContinue | Select-Object -ExpandProperty LastWriteTime
  $needsUpdate = $lastWrite -lt (Get-Date).AddHours(-1)
  $versionData = Import-CliXml $versionCache

  if ($needsUpdate) {
    Get-Job -Name "Update Version Information" -ErrorAction SilentlyContinue | Remove-Job
    Start-Job -Name 'Update Version Information' -ScriptBlock $updateVersionInfo | Out-Null
  }
}

$versionData | Format-VersionTable
