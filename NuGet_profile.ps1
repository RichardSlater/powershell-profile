Afunction Set-ProjectPreferences {
    Get-Project -all | %{ $_.Properties | ?{ $_.Name -eq "WebApplication.StartWebServerOnDebug" } | %{ $_.Value = "False"} };
    Write-Host "'Always Start When Debugging' has been disabled for all web projects.";
}

function Repair-ProjectPackages {
  Update-Package -Reinstall;
}

function Update-ProjectFramework ($Version = '4.6.1') {
  Get-Project -All | Where-Object { $_.Type -Ne "Unknown" } | ForEach-Object {
    $_.Properties["TargetFrameworkMoniker"].Value = ".NETFramework,Version=v$Version";
  }
}
