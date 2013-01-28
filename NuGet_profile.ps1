function SetPrefs(){
    Get-Project -all | %{ $_.Properties | ?{ $_.Name -eq "WebApplication.StartWebServerOnDebug" } | %{ $_.Value = "False"} }
    Write-Host "'Always Start When Debugging' has been disabled for all web projects."
}

function KillCassini(){
    Get-Process -Name WebDev.WebServer40 | Stop-Process
}

# http://stackoverflow.com/questions/13085480/restoring-nuget-references
function Fix-NugetPackages
{
    foreach ($project in Get-Project -All) 
    { 
        $packages = Get-Package -ProjectName $project.ProjectName
        foreach ($package in $packages) 
        {
            Uninstall-Package $package.Id -Force -ProjectName $project.ProjectName
        }
        foreach ($package in $packages) 
        {
            Install-Package $package.Id -ProjectName $project.ProjectName -Version $package.Version
        }
    }
}
