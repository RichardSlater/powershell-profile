@{
  Name = "Packer";
  ActiveVersion = {
    $unparsedVersion = $(& packer --version)
    $isInstalled = ($unparsedVersion | Where-Object { -Not [String]::IsNullOrWhiteSpace($_) }) -match '\d+\.\d+\.\d+'
    if ($isInstalled) {
      return $matches[0]
    } else {
      return "N/A"
    }
  };
  LatestVersion = {
    $updateCheck = Invoke-RestMethod -Uri "https://checkpoint-api.hashicorp.com/v1/check/packer"
    return $updateCheck.current_version
  }
}
