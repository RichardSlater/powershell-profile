@{
  Name = "Vagrant";
  ActiveVersion = {
    $activeVersion = Get-Command vagrant | Select-Object -ExpandProperty Source
    $unparsedVersion = $(& $activeVersion --version)
    $isInstalled = ($unparsedVersion | Where-Object { -Not [String]::IsNullOrWhiteSpace($_) }) -match '\d+\.\d+\.\d+'
    if ($isInstalled) {
      return $matches[0]
    } else {
      return "N/A"
    }
  };
  LatestVersion = {
    $updateCheck = Invoke-RestMethod -Uri "https://checkpoint-api.hashicorp.com/v1/check/vagrant"
    return $updateCheck.current_version
  }
}
