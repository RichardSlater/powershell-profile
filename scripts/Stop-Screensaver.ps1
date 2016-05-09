[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

function Stop-Screensaver ($minutes = 120) {
  for ($i = 0; $i -lt $minutes; $i++) {
    Start-Sleep -Seconds 60
    $Pos = [System.Windows.Forms.Cursor]::Position
    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point((($Pos.X) + 5) , $Pos.Y)
  }
}
