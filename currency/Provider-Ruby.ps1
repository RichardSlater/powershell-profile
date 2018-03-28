@{
  Name = "Ruby";
  ActiveVersion = {
    $activeVersion = Get-Command ruby | Select-Object -ExpandProperty Source
    $unparsedVersion = $(& $activeVersion --version)
    $isInstalled = ($unparsedVersion | Where-Object { -Not [String]::IsNullOrWhiteSpace($_) }) -match '\d+\.\d+\.\d+'
    if ($isInstalled) {
      return $matches[0]
    } else {
      return "N/A"
    }
  };
  LatestVersion = {
    $updateCheck = Invoke-RestMethod -Uri "https://api.github.com/repos/oneclick/rubyinstaller2/releases"
    $unParsedVersion = $updateCheck | Select-Object -First 1 -ExpandProperty name
    $isInstalled = ($unparsedVersion | Where-Object { -Not [String]::IsNullOrWhiteSpace($_) }) -match '\d+\.\d+\.\d+'
    if ($isInstalled) {
      return $matches[0]
    } else {
      return "N/A"
    }
  }
}
