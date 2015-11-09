function Get-ContentColor ([string]$ScriptPath) {
  $breakpointLines = Get-PSBreakpoint -Script $ScriptPath | Select-Object -ExpandProperty Line;
  $currentBackgroundColor = $Host.UI.RawUI.BackgroundColor;
  $colorizer = New-Object ColorCode.CodeColorizer;
  $colorFormatter = New-Object RichardSlater.AnsiFormatter;
  $colorStylesheet = New-Object ColorCode.Styling.StyleSheets.DefaultStyleSheet;
  $language = [ColorCode.Languages]::PowerShell;

  Invoke-Expression ("Get-Content $ScriptPath") | ForEach-Object {
    if ($breakpointLines -Contains $_.ReadCount) {
      $bg = "Red";
      $bpChar = "*"
    } else {
      $bg = $currentBackgroundColor;
      $bpChar = " ";
    }

    Write-Host -ForegroundColor White ("{0}:{1}" -f $_.ReadCount.ToString().PadLeft(3, ' '), $bpChar) -NoNewLine -BackgroundColor $bg;
    $colorized = New-Object System.Text.StringBuilder;
    $colorWriter = New-Object System.IO.StringWriter($colorized);

    if ($_.Length -lt ($Host.UI.RawUI.WindowSize.Width - 9)) {
      $colorizer.Colorize($_, $language, $colorFormatter, $colorStylesheet, $colorWriter);
      if ($bg -eq "Red") {
        Write-Host $colorized.ToString().Replace('[1;31;40m', '[1;5;41m').Replace(';40m', ';5;41m') -BackgroundColor $bg;
        Write-Host -NoNewLine "$([char]27)[0m";
      } else {
        Write-Host $colorized.ToString();
      }
    }
    else {
      $colorizer.Colorize($_.Substring(0, $Host.UI.RawUI.WindowSize.Width - 9), $language, $colorFormatter, $colorStylesheet, $colorWriter);
      if ($bg -eq "Red") {
        Write-Host $colorized.ToString().Replace('[1;31;40m', '[1;5;41m').Replace(';40m', ';5;41m') -BackgroundColor $bg -NoNewLine;
        Write-Host -NoNewLine "$([char]27)[0m";
      } else {
        Write-Host $colorized.ToString() -NoNewLine;
      }
      Write-Host "..." -ForegroundColor Green -BackgroundColor $bg;
    }
  }
}