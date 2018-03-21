Function Update-Terraform($Version = $null, [switch]$WhatIf) {
  $updateCheck = Invoke-RestMethod -Uri 'https://checkpoint-api.hashicorp.com/v1/check/terraform'
  $localDirectory = 'C:\Tools\hashicorp\'
  $latestVersion = $updateCheck.current_version
  $targetVersion = if ($Version) { $version } else { $latestVersion }
  $activeTerraform = Join-Path $localDirectory 'terraform.exe'
  $currentVersion = (& $activeTerraform --version).Split(' ')[1].Substring(1)
  $backupDirectory = Join-Path $localDirectory $currentVersion
  $backupExecutable = Join-Path $backupDirectory "terraform.exe"
  $versionDirectory = Join-Path $localDirectory $targetVersion
  $downloadFile = "terraform_$($targetVersion)_windows_amd64.zip"
  $downloadUri = "https://releases.hashicorp.com/terraform/$targetVersion/$downloadFile"
  $downloadLocation = Join-Path $versionDirectory $downloadFile

  Write-Host 'Terraform Update' -ForegroundColor White
  Write-Host
  Write-Host '  Latest: ' -ForegroundColor White -NoNewLine
  Write-Host $latestVersion
  Write-Host '  Active: ' -ForegroundColor White -NoNewLine
  Write-Host $currentVersion
  Write-Host '  Target: ' -ForegroundColor White -NoNewLine
  Write-Host $targetVersion
  Write-Host

  if ($WhatIf) {
    Write-Host -ForegroundColor Yellow "`[WhatIf`] Download Terraform $targetVersion from $downloadUri"
    Write-Host -ForegroundColor Yellow "`[WhatIf`] Backup $activeTerraform to $backupDirectory"
    Write-Host -ForegroundColor Yellow "`[WhatIf`] Extract $downloadLocation to $localDirectory"
    Write-Host -ForegroundColor DarkYellow "Simulation Complete"
    return
  }

  if ($targetVersion -ne $currentVersion) {
    Write-Host "Updating..." -ForegroundColor Yellow -NoNewLine
    if (-Not (Test-Path $backupDirectory)) { New-Item -Type Container $backupDirectory | Out-Null }
    if (-Not (Test-Path $versionDirectory)) { New-Item -Type Container $versionDirectory | Out-Null }

    Write-Debug "Download Uri: $downloadUri"
    if (-Not (Test-Path $downloadLocation)) {
      [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
      Invoke-WebRequest -Uri $downloadUri -OutFile $downloadLocation
    }
    try {
      if (Test-Path $backupExecutable) {
        Move-Item $activeTerraform $backupDirectory -Force | Out-Null
      }
      Expand-Archive $downloadLocation -DestinationPath $localDirectory -Force
    } catch {
      if (Test-Path $backupExecutable) {
        Write-Host "Failed... rolling back..." -ForegroundColor Red -NoNewLine
        Move-Item $backupExecutable $activeTerraform | Out-Null
      } else {
        Write-Host "Failed... no backup to restore... sorry about that!" -ForegroundColor Red
      }
    }
    Write-Host "Done" -ForegroundColor Green
  } else {
    Write-Host "Up-to-date" -ForegroundColor Green
  }
}
