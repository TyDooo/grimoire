{
  config,
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.exiftool ];

  programs.yazi = {
    enable = true;

    enableBashIntegration = config.programs.bash.enable;
    enableFishIntegration = config.programs.fish.enable;
    shellWrapperName = "y";
  };
}
