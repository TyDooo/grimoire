{ lib, ... }:
{
  options.modules.services.media.servarr = {
    enable = lib.mkEnableOption "servarr";
  };

  imports = [
    ./bazarr.nix
    ./flaresolverr.nix
    ./sonarr.nix
    ./radarr.nix
    ./prowlarr.nix
    ./profilarr.nix
  ];
}
