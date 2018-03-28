@{
  Name = "NodeJS";
  ActiveVersion = {
    $activeVersion = Get-Command node | Select-Object -ExpandProperty Source
    $unparsedVersion = $(& $activeVersion --version)
    $isInstalled = ($unparsedVersion | Where-Object { -Not [String]::IsNullOrWhiteSpace($_) }) -match '\d+\.\d+\.\d+'
    if ($isInstalled) {
      return $matches[0]
    } else {
      return "N/A"
    }
  };
  LatestVersion = {
    $updateCheck = Invoke-RestMethod -Uri "http://nodejs.org/dist/index.json"
    $unParsedVersion = $updateCheck | Select-Object -First 1 -ExpandProperty version
    $isInstalled = ($unparsedVersion | Where-Object { -Not [String]::IsNullOrWhiteSpace($_) }) -match '\d+\.\d+\.\d+'
    if ($isInstalled) {
      return $matches[0]
    } else {
      return "N/A"
    }
  }
}
