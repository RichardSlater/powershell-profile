# for initializing Ruby envronment
Function Initialize-Ruby() {
  Push-Location 'C:\Ruby200-x64\bin';
  ./setrbvars.bat;
  Pop-Location;
  Write-Host "`nRuby Environment Configured." -ForegroundColor Green;
}