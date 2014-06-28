$ProfilePath    = Split-Path $profile
$ScriptPath     = Join-Path $ProfilePath bin
$VimPath        = Join-Path $ScriptPath "\vim\vim.exe"
$GourcePath     = Join-Path $ScriptPath "\gource\gource.exe"
$SublimePath    = Join-Path $env:ProgramFiles "\Sublime Text 3\sublime_text.exe"
$DcrawPath      = Join-Path $ScriptPath "\dcraw\dcraw.exe"
$CJpegRootPath  = Join-Path $ScriptPath "cjpeg"
$cjpegPath      = Join-Path $CJpegRootPath "\cjpeg\Release\cjpeg.exe"
$djpegPath      = Join-Path $CJpegRootPath "cjpeg\djpeg\Release\djpeg.exe"
$cjpegTranPath  = Join-Path $CJpegRootPath "cjpeg\jpegtran\Release\jpegtran.exe"
$rdjpegcomPath  = Join-Path $CJpegRootPath "cjpeg\rdjpgcom\Release\rdjpgcom.exe"
$wrjpgcomPath   = Join-Path $CJpegRootPath "wrjpgcom\Release\wrjpgcom.exe"
$whoisPath      = Join-Path $ScriptPath "sysinternals\whois.exe"
$logstalgiaPath = Join-Path $ScriptPath "logstalgia\logstalgia.exe"

. $($ProfilePath + '\Modules\posh-git\profile.example.ps1') # Posh-Git
. $($ProfilePath + '\scripts\Get-ChildItem-Color.ps1') # New-CommandWrapper used by ll

Set-Alias vi         $VimPath
Set-Alias vim        $VimPath
Set-Alias dcraw      $DcrawPath
Set-Alias cjpeg      $cjpegPath
Set-Alias gource     $GourcePath
Set-Alias whois      $whoisPath
Set-Alias logstalgia $logstalgiaPath
Set-Alias sublime    $SublimePath
Set-Alias ll         Get-ChildItem-Color -Option AllScope
Set-Alias lw         Get-ChildItem-Format-Wide -Option AllScope

# for AutoLoading script modules
Get-Module -ListAvailable | ? { $_.ModuleType -eq "Script" } | Import-Module

# for AutoLoading Microsoft modules
if ([Environment]::Is64BitProcess) {
  Get-Module -ListAvailable | ? { $_.Name.StartsWith("Microsoft.") } | Import-Module
}

# for AutoLoading Amido modules
if ([Environment]::Is64BitProcess) {
  Get-Module -ListAvailable | ? { $_.Name.StartsWith("Amido.") } | Import-Module
}

# for editing your PowerShell profile
Function Edit-Profile {
  vim $PROFILE
  . $PROFILE
}

# for editing your Vim settings
Function Edit-Vimrc {
  vim $home\_vimrc
}

# for configururing Git
Function Configure-GitCore {
  $gitIgnorePath = Join-Path $ProfilePath .gitignore
  git config --global user.name "Richard Slater"
  git config --global core.editor vim
  git config --global color.ui true
  git config --global core.autocrlf true
  git config --global core.excludesfile $gitIgnorePath
  git config --global mergetool.vimdiff3.cmd 'vim -f -d -c "wincmd J" "$MERGED" "$LOCAL" "$BASE" "$REMOTE"'
  git config --global merge.tool vimdiff3
  git config --global branch.autosetupmerge true
}

# for configuring git at Amido with suitable settings
Function Configure-GitAmido {
  git config --global user.email richard.slater@amido.com
  Configure-GitCore

  $sshKey = ssh-add -L | Select-String "richard.slater@amido.co.uk";
  if (!$sshKey) {
    $sshKeyFile = Join-Path $env:USERPROFILE "Dropbox\SSH\richard.slater@amido.co.uk.pem";
    ssh-add $sshKeyFile;
  }
}

# for configuring git at home with suitable settings
Function Configure-Git {
  git config --global user.email git@richard-slater.co.uk
  Configure-GitCore
}

Function Visualize-Git {
  git log --oneline --decorate --all --graph --simplify-by-decoration
}

Function Goto-Source {
  if (Test-Path C:\Source) {
    cd C:\Source
  }
}

# for finding files, UNIX like
Function which($name) {
  Get-Command $name | Select-Object Definition
}

# for creating empty files, UNIX like
Function touch($file) {
  "" | Out-File $file -Encoding ASCII
}

# for initilizing the Visual Studio command prompt environment
Function Initialize-VSEnvironment() {
  pushd "C:\Program Files (x86)\Microsoft Visual Studio 12.0\vc"
  cmd /c "vcvarsall.bat & set" |
  foreach {
    if ($_ -match "=") {
      $v = $_.split("="); set-item -force -path "ENV:\$($v[0])" -value "$($v[1])"
    }
  }
  popd
  Write-Host "`nVisual Studio 2013 Command Prompt variables set." -ForegroundColor Yellow
}

# for initializing Ruby envronment
Function Initialize-Ruby() {
  pushd 'C:\Ruby200-x64\bin'
  ./setrbvars.bat
  popd
  Write-Host "`nRuby Environment Configured." -ForegroundColor Yellow
}

function Import-PfxCertificate {
  param(
    [String]$certPath,
    [String]$certRootStore = "CurrentUser",
    [String]$certStore = "My",
    $pfxPass = $null
  )

  $pfx = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2    

  if ($pfxPass -eq $null) { $pfxPass = Read-Host "Enter the pfx password" -AsSecureString }
  
  $pfx.import((Resolve-Path $certPath), $pfxPass, "Exportable,PersistKeySet")    
  
  $store = New-Object System.Security.Cryptography.X509Certificates.X509Store($certStore, $certRootStore)    
  $store.open("MaxAllowed")    
  $store.add($pfx)    
  $store.close()    
}
