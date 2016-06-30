function Set-ProjectPreferences {
    Get-Project -all | %{ $_.Properties | ?{ $_.Name -eq "WebApplication.StartWebServerOnDebug" } | %{ $_.Value = "False"} };
    Write-Host "'Always Start When Debugging' has been disabled for all web projects.";
}

# http://stackoverflow.com/questions/13085480/restoring-nuget-references
function Repair-ProjectPackages {
    Get-Project -All | Get-Package | Sort-Object -Unique Id, Version | Update-Package -Reinstall;
}
