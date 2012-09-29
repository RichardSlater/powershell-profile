$PROFILEPATH = Split-Path $profile
$SCRIPTPATH  = Join-Path $PROFILEPATH bin
$VIMPATH     = Join-Path $SCRIPTPATH "\vim\vim.exe"

Set-Alias vi   $VIMPATH
Set-Alias vim  $VIMPATH

# for editing your PowerShell profile
Function Edit-Profile
{
    vim $profile
}

# for editing your Vim settings
Function Edit-Vimrc
{
    vim $home\_vimrc
}

# for configuring git with suitable settings
Function Configure-Git
{
    git config --global user.name "Richard Slater"
    git config --global user.email git@richard-slater.co.uk
    git config --global core.editor vim
    git config --global color.ui true
    git config --global core.autocrlf true
}
