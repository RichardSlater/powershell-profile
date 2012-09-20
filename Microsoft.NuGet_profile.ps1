function SetPrefs(){
get-project -all | %{ $_.Properties | ?{ $_.Name -eq "WebApplication.StartWebServerOnDebug" } | %{ $_.Value = "False"} }
Write-Host "'Always Start When Debugging' has been disabled for all web projects."
}