# for configururing Git
Function Set-GitCore {
  $env:SSH_AUTH_SOCK = $null;
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
  git config --global push.default simple;
  git config --global pull.rebase true;
  git config --global commit.gpgsign true
  git config --global user.signingkey A6DA3DB0942B2D021B75F6DA973EC875A6E40B5A;
}

# for configuring git at Amido with suitable settings
Function Set-AmidoGitConfiguration {
  git config --global user.email richard.slater@amido.com;
  Set-GitCore;

  $sshKey = ssh-add -L | Select-String "richard.slater@amido.com";
  if (!$sshKey) {
    $sshKeyFile = Join-Path $env:USERPROFILE ".ssh/richard.slater@amido.com-2016";
    ssh-add $sshKeyFile;
  }
}

# for configuring git at home with suitable settings
Function Set-HMCTSGitConfiguration {
  git config --global user.email richard.slater@hmcts.net;
  Set-GitCore;

  $sshKey = ssh-add -L | Select-String "richard.slater@hmcts.net";
  if (!$sshKey) {
    $sshKeyFile = Join-Path $env:USERPROFILE ".ssh\richard.slater@hmcts.net-2018.ed25519";
    ssh-add $sshKeyFile;
  }
}

# for configuring git at home with suitable settings
Function Set-PersonalGitConfiguration {
  git config --global user.email github@richard-slater.co.uk;
  Set-GitCore;

  $sshKey = ssh-add -L | Select-String "github@richard-slater.co.uk";
  if (!$sshKey) {
    $sshKeyFile = Join-Path $env:USERPROFILE ".ssh\richard@richard-slater.co.uk-2018.ed25519";
    ssh-add $sshKeyFile;
  }
}

Function Visualize-Git {
  git log --oneline --decorate --all --graph --simplify-by-decoration;
}
