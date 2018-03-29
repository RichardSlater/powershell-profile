@{
  Name = "Python 2";
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
    $updateCheck = Invoke-WebRequest https://www.python.org/downloads/
    $ProgressPreference = $oldProgress
    $downloadFile = $updateCheck.Links | Where-Object { $_.InnerText -ne $null -And $_.innerText.StartsWith('Python 2') } | Select-Object -First 1 -ExpandProperty innerText
    $isInstalled = ($downloadFile | Where-Object { -Not [String]::IsNullOrWhiteSpace($_) }) -match '\d+\.\d+\.\d+'
    if ($isInstalled) {
      return $matches[0]
    } else {
      return "N/A"
    }
  }
}
