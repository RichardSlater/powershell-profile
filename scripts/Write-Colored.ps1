function Write-Colored([String] $text, [String] $BackgroundColor = $Host.UI.RawUI.BackgroundColor) {
  $split = $text.Split([char] 27);
  foreach ($line in $split){
    if ($line[0] -ne '[') {
      Write-Host $line -NoNewline
    } else {
      if (($line[1] -eq '0') -and ($line[2] -eq 'm')) {
        Write-Host $line.Substring(3) -NoNewline
      } elseif (($line[1] -eq '3') -and ($line[3] -eq 'm')) {
        if     ($line[2] -eq '0') { Write-Host $line.Substring(4) -NoNewline -ForegroundColor Black       -BackgroundColor $BackgroundColor}
        elseif ($line[2] -eq '1') { Write-Host $line.Substring(4) -NoNewline -ForegroundColor DarkRed     -BackgroundColor $BackgroundColor}
        elseif ($line[2] -eq '2') { Write-Host $line.Substring(4) -NoNewline -ForegroundColor DarkGreen   -BackgroundColor $BackgroundColor}
        elseif ($line[2] -eq '3') { Write-Host $line.Substring(4) -NoNewline -ForegroundColor DarkYellow  -BackgroundColor $BackgroundColor}
        elseif ($line[2] -eq '4') { Write-Host $line.Substring(4) -NoNewline -ForegroundColor DarkBlue    -BackgroundColor $BackgroundColor}
        elseif ($line[2] -eq '5') { Write-Host $line.Substring(4) -NoNewline -ForegroundColor DarkMagenta -BackgroundColor $BackgroundColor}
        elseif ($line[2] -eq '6') { Write-Host $line.Substring(4) -NoNewline -ForegroundColor DarkCyan    -BackgroundColor $BackgroundColor}
        elseif ($line[2] -eq '7') { Write-Host $line.Substring(4) -NoNewline -ForegroundColor Gray        -BackgroundColor $BackgroundColor}
      } elseif (($line[1] -eq '3') -and ($line[3] -eq ';') -and ($line[5] -eq 'm')) {
        if     ($line[2] -eq '0') { Write-Host $line.Substring(6) -NoNewline -ForegroundColor DarkGray    -BackgroundColor $BackgroundColor}
        elseif ($line[2] -eq '1') { Write-Host $line.Substring(6) -NoNewline -ForegroundColor Red         -BackgroundColor $BackgroundColor}
        elseif ($line[2] -eq '2') { Write-Host $line.Substring(6) -NoNewline -ForegroundColor Gree        -BackgroundColor $BackgroundColor}
        elseif ($line[2] -eq '3') { Write-Host $line.Substring(6) -NoNewline -ForegroundColor Yellow      -BackgroundColor $BackgroundColor}
        elseif ($line[2] -eq '4') { Write-Host $line.Substring(6) -NoNewline -ForegroundColor Blue        -BackgroundColor $BackgroundColor}
        elseif ($line[2] -eq '5') { Write-Host $line.Substring(6) -NoNewline -ForegroundColor Magenta     -BackgroundColor $BackgroundColor}
        elseif ($line[2] -eq '6') { Write-Host $line.Substring(6) -NoNewline -ForegroundColor Cyan        -BackgroundColor $BackgroundColor}
        elseif ($line[2] -eq '7') { Write-Host $line.Substring(6) -NoNewline -ForegroundColor White       -BackgroundColor $BackgroundColor}
      }
    }
  }
}