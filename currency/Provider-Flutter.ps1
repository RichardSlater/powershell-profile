@{
  Name = "Flutter";
  ActiveVersion = {
    $flutterVersionMachine = $(& flutter --version --machine) | ConvertFrom-Json
    return $flutterVersionMachine.frameworkVersion
  };
  LatestVersion = {
    $flutterVersionMachine = $(& flutter --version --machine) | ConvertFrom-Json
    return $flutterVersionMachine.frameworkVersion
  }
}
