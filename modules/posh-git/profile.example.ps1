Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

# Load posh-git module from current directory
Import-Module .\posh-git

# If module is installed in a default location ($env:PSModulePath),
# use this instead (see about_Modules for more information):
# Import-Module posh-git


# Set up a simple prompt, adding the git prompt parts inside git repos
function global:prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    if (Test-Path variable:/PSDebugContext) {
        Write-Host '[DBG] ' -ForegroundColor Red;
    } 

    Write-Host (Split-Path -Resolve $pwd -Leaf) -NoNewLine -ForegroundColor Cyan;

    Write-VcsStatus;

    $global:LASTEXITCODE = $realLASTEXITCODE;
    return "> ";
}

Pop-Location

Start-SshAgent -Quiet