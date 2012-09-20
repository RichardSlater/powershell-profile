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
