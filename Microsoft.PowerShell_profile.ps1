$SCRIPTPATH = "C:\Users\RichardSlater\Documents\WindowsPowerShell\bin"
$VIMPATH    = $SCRIPTSPATH + "\vim.exe"

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