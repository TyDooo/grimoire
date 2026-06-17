{
  users.users.root.hashedPassword = "*"; # lock root account
  users.users.root.openssh.authorizedKeys.keys = [ (builtins.readFile ../tydooo/ssh.pub) ];

  # Allow to run nix
  nix.settings.allowed-users = [ "root" ];
}
