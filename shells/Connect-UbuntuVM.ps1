$vm = Get-VM -Name "Ubuntu Server 17.04";
$adapter = $vm | Get-VMNetworkAdapter;
$ip = $adapter.IPAddresses | Where-Object { $_.Length -lt 16 };
$env:TERM = "xterm-color"
$env:DISPLAY = ":0.0"
& ssh -Y "richa@$ip"
