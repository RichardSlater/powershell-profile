function Update-Terraform($Version = $null, [switch]$WhatIf) {
  Update-Hashicorp -Product "terraform" -Version $Version -WhatIf:$WhatIf
}

function Update-Packer($Version = $null, [switch]$WhatIf) {
  Update-Hashicorp -Product "packer" -Version $Version -WhatIf:$WhatIf
}

Function Update-Hashicorp($Product, $Version = $null, [switch]$WhatIf) {
  $updateCheck = Invoke-RestMethod -Uri "https://checkpoint-api.hashicorp.com/v1/check/$Product"
  $localDirectory = 'C:\Tools\hashicorp\'
  $latestVersion = $updateCheck.current_version
  $targetVersion = if ($Version) { $version } else { $latestVersion }
  $activeVersion = Join-Path $localDirectory "$Product.exe"
  $unparsedVersion = $(& $activeVersion --version) | Where-Object { -Not [String]::IsNullOrWhiteSpace($_) } | Select-Object -First 1
  $isInstalled = $unparsedVersion[0] -match '\d+\.\d+\.\d+'
  $currentVersion = if ($isInstalled) { $matches[0] } else { "N/A" }
  $backupDirectory = Join-Path $localDirectory "$($Product)-$currentVersion"
  $backupExecutable = Join-Path $backupDirectory "$Product.exe"
  $versionDirectory = Join-Path $localDirectory "$($Product)-$targetVersion"
  $downloadFile = "$($Product)_$($targetVersion)_windows_amd64.zip"
  $downloadUri = "https://releases.hashicorp.com/$Product/$targetVersion/$downloadFile"
  $downloadLocation = Join-Path $versionDirectory $downloadFile

  Write-Host "$Product update" -ForegroundColor White
  Write-Host
  Write-Host '  Latest: ' -ForegroundColor White -NoNewLine
  Write-Host $latestVersion
  Write-Host '  Active: ' -ForegroundColor White -NoNewLine
  Write-Host $currentVersion
  Write-Host '  Target: ' -ForegroundColor White -NoNewLine
  Write-Host $targetVersion
  Write-Host

  if ($WhatIf) {
    Write-Host -ForegroundColor Yellow "`[WhatIf`] Download $targetVersion from $downloadUri"
    Write-Host -ForegroundColor Yellow "`[WhatIf`] Backup $activeVersion to $backupDirectory"
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
      if (Test-Path $activeVersion) {
        Move-Item $activeVersion $backupDirectory -Force | Out-Null
      }
      Expand-Archive $downloadLocation -DestinationPath $localDirectory -Force
    } catch {
      Write-Host $_.Exception
      if (Test-Path $backupExecutable) {
        Write-Host "Failed... rolling back..." -ForegroundColor Red -NoNewLine
        Move-Item $backupExecutable $activeVersion | Out-Null
      } else {
        Write-Host "Failed... no backup to restore... sorry about that!" -ForegroundColor Red
      }
    }
    Write-Host "Done" -ForegroundColor Green
  } else {
    Write-Host "Up-to-date" -ForegroundColor Green
  }
}
