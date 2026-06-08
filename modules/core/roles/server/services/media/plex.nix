{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.modules.services.media.plex;
in
{
  options.modules.services.media.plex = {
    enable = mkEnableOption "plex";
  };

  config = mkIf cfg.enable {
    services.plex = {
      enable = true;
      openFirewall = true;
    };

    users.users.plex.extraGroups = [ "media" ];

    environment.persistence = {
      "/persist".directories = [
        {
          directory = config.services.plex.dataDir;
          inherit (config.services.plex) user group;
          mode = "0700";
        }
      ];
    };
  };
}
