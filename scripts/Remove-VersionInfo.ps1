function Remove-VersionInfo () {
  Remove-Item "$PSScriptRoot\..\currency\versionCache.xml"
}
