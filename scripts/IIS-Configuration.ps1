Import-Module WebAdministration

function Create-ManagedWebsite {
  param(
    [Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true)]
    [System.String]$DomainName
  )

  $hostName = $env:COMPUTERNAME
  $webRoot = Join-Path C:\sites $DomainName
  $logsDirectory = Join-Path C:\logs $DomainName
  $iisAppPool = Join-Path 'IIS:\AppPools' $DomainName
  $iisSite = Join-Path 'IIS:\Sites' $DomainName

  $webRootExists = Test-Path $webRoot
  $logsDirectoryExists = Test-Path $logsDirectory
  $iisAppPoolExists = Test-Path $iisAppPool
  $iisSiteExists = Test-Path $iisSite

  if ($webRootExists) {
    Write-Host $webRoot already exists not creating site -foregroundcolor Red
  }

  if ($logsDirectoryExists) {
    Write-Host $logsDirectory already exists not creating site -foregroundcolor Red
  }

  if ($iisAppPoolExists) {
    Write-Host $iisAppPool already exists not creating site -foregroundcolor Red
  }

  if ($iisSiteExists) {
    Write-Host $iisSite already exists not creating site -foregroundcolor Red
  }

  if ($webRootExists -or $logsDirectoryExists -or $iisAppPoolExists -or $iisSiteExists) {
    exit
  }

  Write-Host 'IIS Site' $iisSite -foregroundcolor Green
  Write-Host '  Web Root: ' $webRoot -foregroundcolor Green
  Write-Host '  Logs Directory: ' $logsDirectory -foregroundcolor Green
  Write-Host '  AppPool' $iisAppPool -foregroundcolor Green

  New-Item $webRoot -type Directory 

  New-Item $iisAppPool

  New-Item $iisSite -physicalPath $webRoot -bindings @{protocol='http';bindingInformation=':80:' + $DomainName}

  Set-ItemProperty $iisSite -name applicationPool -value $DomainName

  [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.Web.Management") 
  [Microsoft.Web.Management.Server.ManagementAuthorization]::Grant($hostname + '\WebDeploy', $DomainName, $FALSE)

  New-Item $logsDirectory -type Directory 
  Set-ItemProperty $iisSite -name logFile.directory -value $logsDirectory
  Set-ItemProperty $iisSite -name logFile.logExtFileFlags -value 2228175
}

function Delete-ManagedWebsite {
  param(
    [Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true)]
    [System.String]$DomainName
  )

  $hostName = $env:COMPUTERNAME
  $webRoot = Join-Path C:\sites $DomainName
  $logsDirectory = Join-Path C:\logs $DomainName
  $iisAppPool = Join-Path 'IIS:\AppPools' $DomainName
  $iisSite = Join-Path 'IIS:\Sites' $DomainName

  $webRootExists = Test-Path $webRoot
  $logsDirectoryExists = Test-Path $logsDirectory
  $iisAppPoolExists = Test-Path $iisAppPool
  $iisSiteExists = Test-Path $iisSite

  if ($iisSiteExists) {
    Remove-Item $iisSite -Recurse -Force
  }

  if ($iisAppPoolExists) {
    Remove-Item $iisAppPool -Recurse -Force
  }

  if ($webRootExists) {
    Remove-Item $webRoot -Recurse -Force
  }

  if ($logsDirectoryExists) {
    Remove-Item $logsDirectory -Recurse -Force
  }

  [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.Web.Management") 
  [Microsoft.Web.Management.Server.ManagementAuthorization]::Revoke($hostname + '\WebDeploy')
}

Delete-ManagedWebsite cms.client.environment.cloud.com
Create-ManagedWebsite cms.client.environment.cloud.com
