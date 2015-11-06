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
  git config --global diff.tool.bc4;
  git config --global difftool.bc4.path $BeyondCompPath;
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