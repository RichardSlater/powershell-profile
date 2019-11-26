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
    $latest = $updateCheck | Select-Object -ExpandProperty name |
      Where-Object { -Not [String]::IsNullOrWhiteSpace($_) -And $_ -match '\d+\.\d+\.\d+' } |
      Select-Object @{l="Version";e={[Version]::Parse($_.Replace("RubyInstaller-","").Split(" ")[0].Split("-")[0])}} |
      Sort-Object Version -Descending |
      Select-Object -First 1

    return $latest.Version.ToString()
  }
}
