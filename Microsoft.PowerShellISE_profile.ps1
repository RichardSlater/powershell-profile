$ProfilePath    = Split-Path $PROFILE;
$ScriptPath     = Join-Path $ProfilePath bin;
$VimPath        = Join-Path $ScriptPath "\vim\vim.exe";
$GourcePath     = Join-Path $ScriptPath "\gource\gource.exe";
$SublimePath    = Join-Path $env:ProgramFiles "\Sublime Text 3\sublime_text.exe";
$DcrawPath      = Join-Path $ScriptPath "\dcraw\dcraw.exe";
$CJpegRootPath  = Join-Path $ScriptPath "cjpeg";
$cjpegPath      = Join-Path $CJpegRootPath "cjpeg\Release\cjpeg.exe";
$djpegPath      = Join-Path $CJpegRootPath "cjpeg\djpeg\Release\djpeg.exe";
$cjpegTranPath  = Join-Path $CJpegRootPath "cjpeg\jpegtran\Release\jpegtran.exe";
$rdjpegcomPath  = Join-Path $CJpegRootPath "cjpeg\rdjpgcom\Release\rdjpgcom.exe";
$wrjpgcomPath   = Join-Path $CJpegRootPath "wrjpgcom\Release\wrjpgcom.exe";
$whoisPath      = Join-Path $ScriptPath "sysinternals\whois.exe";
$logstalgiaPath = Join-Path $ScriptPath "logstalgia\logstalgia.exe";

. $($ProfilePath + '\scripts\Get-ChildItemColor.ps1'); # Command Wrapper used by ll

Set-Alias vi         $VimPath;
Set-Alias vim        $VimPath;
Set-Alias dcraw      $DcrawPath;
Set-Alias cjpeg      $cjpegPath;
Set-Alias gource     $GourcePath;
Set-Alias whois      $whoisPath;
Set-Alias logstalgia $logstalgiaPath;
Set-Alias sublime    $SublimePath;
Set-Alias ll         Get-ChildItemColor -Option AllScope;

# for AutoLoading script modules
Get-Module -ListAvailable | ? { $_.ModuleType -eq "Script" } | Import-Module;

# for AutoLoading Microsoft modules
if ([Environment]::Is64BitProcess) {
  Get-Module -ListAvailable | ? { $_.Name.StartsWith("Microsoft.") } | Import-Module;
}

# for AutoLoading Amido modules
if ([Environment]::Is64BitProcess) {
  Get-Module -ListAvailable | ? { $_.Name.StartsWith("Amido.") } | Import-Module;
}

# for supressing of echo of command line
$Pscx:Preferences['CD_EchoNewLocation'] = $false;

# for editing your PowerShell profile
Function Edit-PowershellProfile {
  vim $PROFILE;
  . $PROFILE;
}

# for editing your Vim settings
Function Edit-Vimrc {
  vim $home\_vimrc;
}

# for configururing Git
Function Set-GitCore {
  $gitIgnorePath = Join-Path $ProfilePath .gitignore;
  git config --global user.name "Richard Slater";
  git config --global core.editor vim;
  git config --global color.ui true;
  git config --global core.autocrlf true;
  git config --global core.excludesfile $gitIgnorePath;
  git config --global mergetool.vimdiff3.cmd 'vim -f -d -c "wincmd J" "$MERGED" "$LOCAL" "$BASE" "$REMOTE"';
  git config --global merge.tool vimdiff3;
  git config --global branch.autosetupmerge true;
}

# for configuring git at Amido with suitable settings
Function Set-AmidoGitConfiguration {
  git config --global user.email richard.slater@amido.com;
  Set-GitCore;

  $sshKey = ssh-add -L | Select-String "richard.slater@amido.co.uk";
  if (!$sshKey) {
    $sshKeyFile = Join-Path $env:USERPROFILE "Dropbox\SSH\richard.slater@amido.co.uk-2013_rsa";
    ssh-add $sshKeyFile;
  }
}

# for configuring git at home with suitable settings
Function Set-PersonalGitConfiguration {
  git config --global user.email git@richard-slater.co.uk;
  Set-GitCore;

  $sshKey = ssh-add -L | Select-String "github@richard-slater.co.uk";
  if (!$sshKey) {
    $sshKeyFile = Join-Path $env:USERPROFILE "Dropbox\SSH\github@richard-slater.co.uk-2011_rsa";
    ssh-add $sshKeyFile;
  }
}

Function Visualize-Git {
  git log --oneline --decorate --all --graph --simplify-by-decoration;
}

Function Goto-Source {
  $source = "C:\Source";
  if (Test-Path $source) {
    cd $source;
  }
}

# for finding files, UNIX like
Function Trace-Command($name) {
  Get-Command $name | Select-Object Definition;
}

# for creating empty files, UNIX like
Function New-File($file) {
  if (Test-Path $file) {
    $date = Get-Date;
    Get-Item $file | ForEach-Object {
      $_.LastAccessTime = $date;
      $_.LastWriteTime = $date;
    }
  } else {
    [String]::Empty | Out-File $file -Encoding ASCII;
  }
}

# for initilizing the Visual Studio command prompt environment
Function Initialize-VSEnvironment() {
  Push-Location "C:\Program Files (x86)\Microsoft Visual Studio 12.0\vc";
  cmd /c "vcvarsall.bat & set" |
  foreach {
    if ($_ -match "=") {
      $v = $_.split("="); set-item -force -path "ENV:\$($v[0])" -value "$($v[1])";
    }
  }
  Pop-Location;
  Write-Host "`nVisual Studio 2013 Command Prompt variables set." -ForegroundColor Green;
}

# for initializing Ruby envronment
Function Initialize-Ruby() {
  Push-Location 'C:\Ruby200-x64\bin';
  ./setrbvars.bat;
  Pop-Location;
  Write-Host "`nRuby Environment Configured." -ForegroundColor Green;
}

Set-StrictMode -Version Latest;
$Global:DebugPreference = "Continue";
