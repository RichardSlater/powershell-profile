function Get-ContentColor ([string]$ScriptPath) {
  $breakpointLines = Get-PSBreakpoint -Script $ScriptPath | Select-Object -ExpandProperty Line;
  $currentBackgroundColor = $Host.UI.RawUI.BackgroundColor;

  Invoke-Expression ("Get-Content $ScriptPath") | ForEach-Object {
    if ($breakpointLines -Contains $_.ReadCount) {
      $bg = "Red";
    } else {
      $bg = $currentBackgroundColor;
    }

    Write-Host -ForegroundColor White ("{0}: " -f $_.ReadCount.ToString().PadLeft(3, ' ')) -NoNewLine -BackgroundColor $bg;
    if ($_.Length -lt ($Host.UI.RawUI.WindowSize.Width - 9)) {
      Write-Host $_ -BackgroundColor $bg;
    }
    else {
      Write-Host $_.Substring(0, $Host.UI.RawUI.WindowSize.Width - 9) -NoNewLine -BackgroundColor $bg;
      Write-Host "..." -ForegroundColor Green -BackgroundColor $bg;
    }
  }
}