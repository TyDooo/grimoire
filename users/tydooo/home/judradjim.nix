{
  imports = [
    ./common.nix

    ./desktop
  ];

  programs.git.settings.signing = {
    key = "39EB68CAC6016379";
    signByDefault = true;
  };

  home.stateVersion = "26.11";
}
