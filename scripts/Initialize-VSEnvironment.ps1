# for initilizing the Visual Studio command prompt environment
Function Initialize-VSEnvironment() {
  Push-Location "C:\Program Files (x86)\Microsoft Visual Studio 14.0\vc";
  cmd /c "vcvarsall.bat & set" |
  foreach {
    if ($_ -match "=") {
      $v = $_.split("="); set-item -force -path "ENV:\$($v[0])" -value "$($v[1])";
    }
  }
  Pop-Location;
  Write-Host "`nVisual Studio 2015 Command Prompt variables set." -ForegroundColor Green;
}
