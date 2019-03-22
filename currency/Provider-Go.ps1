@{
  Name = "Go";
  ActiveVersion = {
    $activeVersion = Get-Command go | Select-Object -ExpandProperty Source
    $unparsedVersion = $(& $activeVersion version)
    $isInstalled = ($unparsedVersion | Where-Object { -Not [String]::IsNullOrWhiteSpace($_) }) -match '\d+\.\d+'
    if ($isInstalled) {
      return $matches[0]
    } else {
      return "N/A"
    }
  };
  LatestVersion = {
    $oldProgress = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'
    $updateCheck = Invoke-WebRequest -UseBasicParsing https://golang.org/dl/
    $ProgressPreference = $oldProgress
    $downloadFile = $updateCheck.Links | Where-Object { $_.href.EndsWith('amd64.zip') } | Select-Object -First 1
    $isInstalled = ($downloadFile | Where-Object { -Not [String]::IsNullOrWhiteSpace($_) }) -match '\d+\.\d+'
    if ($isInstalled) {
      return $matches[0]
    } else {
      return "N/A"
    }
  }
}
