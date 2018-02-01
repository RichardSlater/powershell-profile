Set-StrictMode -Version Latest;
$Global:DebugPreference = "SilentlyContinue";
$Global:VerbosePreference = "SilentlyContinue";

$stopwatch      = [System.Diagnostics.Stopwatch]::StartNew();
$ProfilePath    = Split-Path $PROFILE;
$ScriptPath     = Join-Path $ProfilePath bin;
$VimPath        = Join-Path $ScriptPath "\vim\vim.exe";
$GourcePath     = Join-Path $ScriptPath "\gource\gource.exe";
$SublimePath    = "C:\Program Files\Sublime Text 3\sublime_text.exe";
$BeyondCompPath = "C:\Program Files (x86)\Beyond Compare 4\BComp.exe";
$DcrawPath      = Join-Path $ScriptPath "\dcraw\dcraw.exe";
$CJpegRootPath  = Join-Path $ScriptPath "cjpeg";
$cjpegPath      = Join-Path $CJpegRootPath "cjpeg\Release\cjpeg.exe";
$djpegPath      = Join-Path $CJpegRootPath "cjpeg\djpeg\Release\djpeg.exe";
$cjpegTranPath  = Join-Path $CJpegRootPath "cjpeg\jpegtran\Release\jpegtran.exe";
$rdjpegcomPath  = Join-Path $CJpegRootPath "cjpeg\rdjpgcom\Release\rdjpgcom.exe";
$wrjpgcomPath   = Join-Path $CJpegRootPath "wrjpgcom\Release\wrjpgcom.exe";
$whoisPath      = Join-Path $ScriptPath "sysinternals\whois.exe";
$logstalgiaPath = Join-Path $ScriptPath "logstalgia\logstalgia.exe";

$ProfileTimings = @{};

$codeFiles = Get-ChildItem -Path "$ProfilePath\code" -Filter "*.cs";
foreach ($code in $codeFiles) {
  $dependenciesPath = Join-Path -Path $code.Directory -ChildPath $code.BaseName;
  $dependencies = Get-ChildItem -Path (Join-Path $code.Directory  $code.BaseName) -Filter *.dll;

  try {
    $dependencies | ForEach-Object { Add-Type -Path $_.FullName };
    Add-Type -LiteralPath $code.FullName -ReferencedAssemblies $dependencies.FullName;
  }
  catch
  {
    if ($_.Exception.GetType() -eq "ReflectionTypeLoadException")
    {
      $typeLoadException = $_.Exception;
      $loaderExceptions  = typeLoadException.LoaderExceptions;
      $loaderExceptions | Write-Host;
    }
  }
}

Get-ChildItem "$ProfilePath\scripts" -Filter *.ps1 | ForEach-Object {
  $sw = [System.Diagnostics.Stopwatch]::StartNew();
  . $_.FullName
  $sw.Stop();
  $ProfileTimings.Add($_.Name, $sw.Elapsed);
};

$global:WindowsIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent();
$global:WindowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal($WindowsIdentity);
$global:IsAdmin = $WindowsPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator);

function global:prompt {
  $realLASTEXITCODE = $LASTEXITCODE

  if (Test-Path variable:/PSDebugContext) {
    Write-Host '[DBG] ' -ForegroundColor Blue -NoNewLine;
  } elseif ($IsAdmin) {
    Write-Host '[ADM] ' -ForegroundColor Red -NoNewLine;
  } else {
    Write-Host '[PS] ' -ForegroundColor White -NoNewLine;
  }

  Write-Host "$([Net.Dns]::GetHostName()) " -ForegroundColor Green -NoNewLine

  if ($PWD.Path -eq $HOME) {
    Write-Host '~' -NoNewLine -ForegroundColor Cyan;
  } else {
    Write-Host (Split-Path -Resolve $pwd -Leaf) -NoNewLine -ForegroundColor Cyan;
  }

  Write-VcsStatus;

  $global:LASTEXITCODE = $realLASTEXITCODE;
  return "> ";
}

Set-Alias vi         $VimPath;
Set-Alias vim        $VimPath;
Set-Alias dcraw      $DcrawPath;
Set-Alias cjpeg      $cjpegPath;
Set-Alias gource     $GourcePath;
Set-Alias whois      $whoisPath;
Set-Alias logstalgia $logstalgiaPath;
Set-Alias sublime    $SublimePath;
Set-Alias ll         Get-ChildItemColor -Option AllScope;
Set-Alias cat        Get-ContentColor -Option AllScope;

if (Test-Path ~\MachineModules.ps1) {
  . ~\MachineModules.ps1;
}

if (Get-Command chef -CommandType Application -ErrorAction "SilentlyContinue") {
  chef shell-init powershell | Invoke-Expression;
}

Write-Host "Windows PowerShell Console`n--------------------------`n" -ForegroundColor Green;
Write-Host "Windows: `t" -ForegroundColor White -NoNewLine;
Write-Host ([System.Environment]::OSVersion.Version).ToString();
Write-Host "PowerShell: `t" -ForegroundColor White -NoNewLine;
Write-Host (Get-Host).Version.ToString();
Write-Host "Node: `t`t" -ForegroundColor White -NoNewLine;
(& node --version).Substring(1);
Write-Host "Ruby: `t`t" -ForegroundColor White -NoNewLine;
(& ruby --version).Split(' ')[1];
Write-Host "Go: `t`t" -ForegroundColor White -NoNewLine;
(& go version).split(' ')[2].Substring(2);
Write-Host "Terraform: `t" -ForegroundColor White -NoNewLine;
(& terraform --version).Split(' ')[1].Substring(1);
Write-Host "Vagrant: `t" -ForegroundColor White -NoNewLine;
(& vagrant --version).Split(' ')[1];
Write-Host "Packer: `t" -ForegroundColor White -NoNewLine;
(& packer --version);
$stopwatch.Stop();
$timingColor = if ($stopwatch.Elapsed.Seconds -lt 5) { "Green" } elseif ($stopwatch.Elapsed.Seconds -lt 10) { "Yellow" } else { "Red" }
Write-Host "`nProfile loaded in $($stopwatch.Elapsed.Seconds) seconds and $($stopwatch.Elapsed.Milliseconds) milliseconds.`n" -ForegroundColor $timingColor;

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
