# for editing your PowerShell profile
Function Edit-PowershellProfile {
  vim $PROFILE;
  . $PROFILE;
}