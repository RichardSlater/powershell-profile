Function Push-SourceDirectory {
  $source = "C:\Source";
  if (Test-Path $source) {
    Push-Location $source;
  }
}