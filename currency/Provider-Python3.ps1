@{
  Name = "Python 3";
  ActiveVersion = {
    $unparsedVersion = & python -c 'import sys; print(""."".join(map(str, sys.version_info[:3])))'
    $isInstalled = ($unparsedVersion | Where-Object { -Not [String]::IsNullOrWhiteSpace($_) }) -match '\d+\.\d+\.\d+'
    if ($isInstalled) {
      return $matches[0]
    } else {
      return "N/A"
    }
  };
  LatestVersion = {
    $oldProgress = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'
    $updateCheck = Invoke-WebRequest -UseBasicParsing https://www.python.org/downloads/
    $ProgressPreference = $oldProgress
    $downloadFile = $updateCheck.Links | Where-Object { $_.OuterHtml.Contains('Python 3') } | Select-Object -First 1 -ExpandProperty outerHtml
    $isInstalled = $downloadFile -match '\d+\.\d+\.\d+'
    if ($isInstalled) {
      return $matches[0]
    } else {
      return "N/A"
    }
  }
}
