function Remove-VersionInfo () {
  Remove-Item "$($env:ProgramData)/versions/versionCache.xml"
}
