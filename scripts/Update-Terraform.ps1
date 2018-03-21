Function Update-Terraform() {
  $updateCheck = Invoke-RestMethod -Uri 'https://checkpoint-api.hashicorp.com/v1/check/terraform'
  $localDirectory = 'C:\Tools\hashicorp\'
  $latestVersion = $updateCheck.current_version
  $activeTerraform = Join-Path $localDirectory 'terraform.exe'
  $currentVersion = (& $activeTerraform --version).Split(' ')[1].Substring(1)
  $backupDirectory = Join-Path $localDirectory $currentVersion
  $versionDirectory = Join-Path $localDirectory $latestVersion
  $downloadFile = "terraform_$($latestVersion)_windows_amd64.zip"
  $downloadUri = "https://releases.hashicorp.com/terraform/$latestVersion/$downloadFile"
  $downloadLocation = Join-Path $versionDirectory $downloadFile

  Write-Host "Terraform Update Tool:"
  Write-Host "Active: " -ForegroundColor White -NoNewLine
  Write-Host $currentVersion
  Write-Host "Latest: " -ForegroundColor White -NoNewLine
  Write-Host $latestVersion
  Write-Host ""

  if ($latestVersion -ne $currentVersion) {
    Write-Host "Updating..." -ForegroundColor Yellow
    New-Item -Type Container $backupDirectory -Force | Out-Null
    New-Item -Type Container $versionDirectory -Force | Out-Null

    Write-Debug "Download Uri: $downloadUri"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    if (Test-Path $downloadLocation) {
      Remove-Item $downloadLocation
    }
    Invoke-WebRequest -Uri $downloadUri -OutFile $downloadLocation
    try {
      Move-Item $activeTerraform $backupDirectory -Force | Out-Null
      Expand-Archive $downloadLocation -DestinationPath $localDirectory -Force
    } catch {
      Write-Host "Failed... rolling back" -ForegroundColor Red
      Move-Item "$backupDirectory/terraform.exe" $activeTerraform | Out-Null
    }
    Write-Host "Done" -ForegroundColor Green
  } else {
    Write-Host "Up-to-date" -ForegroundColor Green
  }
}
