function SetPrefs(){
    Get-Project -all | %{ $_.Properties | ?{ $_.Name -eq "WebApplication.StartWebServerOnDebug" } | %{ $_.Value = "False"} }
    Write-Host "'Always Start When Debugging' has been disabled for all web projects."
}

function KillCassini(){
    Get-Process -Name WebDev.WebServer40 | Stop-Process
}
