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

$versionData = $null
if (-Not (Test-Path ($versionCache))) {
  $versionData = & "$PSScriptRoot/Update-VersionInfoScheduled.ps1"
} else {
  $lastWrite = Get-ChildItem $versionCache -ErrorAction SilentlyContinue | Select-Object -ExpandProperty LastWriteTime
  $needsUpdate = $lastWrite -lt (Get-Date).AddHours(-1)
  $versionData = Import-CliXml $versionCache

  if (($null -eq $versionData) -Or ($versionData.Length -eq 0)) {
    $versionData = & "$PSScriptRoot/Update-VersionInfoScheduled.ps1"
  } elseif ($needsUpdate) {
    Get-Job -Name "Update Version Information" -ErrorAction SilentlyContinue | Remove-Job
    Start-Job -Name 'Update Version Information' -FilePath "$PSScriptRoot\Update-VersionInfoScheduled.ps1" -ArgumentList $PSScriptRoot | Out-Null
  }
}
$versionData | Format-VersionTable
