{ lib, ... }:
{
  options.modules.services.media.servarr = {
    enable = lib.mkEnableOption "servarr";
  };

  imports = [
    ./bazarr.nix
    ./sonarr.nix
    ./radarr.nix
    ./prowlarr.nix
    ./profilarr.nix
  ];
}
