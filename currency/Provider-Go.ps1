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
    $updateCheck = Invoke-WebRequest https://golang.org/dl/
    $ProgressPreference = $oldProgress
    $downloadFile = $updateCheck.Links | Where-Object { $_.OuterText.EndsWith('amd64.zip') } | Select-Object -First 1 -ExpandProperty innerText
    $isInstalled = ($downloadFile | Where-Object { -Not [String]::IsNullOrWhiteSpace($_) }) -match '\d+\.\d+'
    if ($isInstalled) {
      return $matches[0]
    } else {
      return "N/A"
    }
  }
}
