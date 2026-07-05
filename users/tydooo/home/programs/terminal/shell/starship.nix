{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings.hostname = {
      ssh_only = true;
      disabled = false;
    };
  };
}
