{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.modules.services.media.stash;
in
{
  options.modules.services.media.stash = {
    enable = mkEnableOption "stash";
  };

  config = mkIf cfg.enable {
    services.stash = {
      enable = true;
      openFirewall = true;
      username = "TyDooo";
      passwordFile = config.sops.secrets."stash/password".path;
      sessionStoreKeyFile = config.sops.secrets."stash/session_store_key".path;
      jwtSecretKeyFile = config.sops.secrets."stash/jwt_secret_key".path;
      mutableSettings = true;
      mutableScrapers = true;
      mutablePlugins = true;
      settings = {
        host = "0.0.0.0";
        port = 6969;
        stash = [
          {
            path = "/mnt/disks/tank/sauce/data";
            excludeimage = true;
          }
          {
            path = "/mnt/disks/tank/sauce/hentai";
            excludeimage = true;
          }
        ];
      };
    };

    environment.systemPackages = with pkgs; [
      google-chrome
    ];

    sops.secrets = {
      "stash/password" = {
        owner = config.services.stash.user;
        inherit (config.services.stash) group;
        mode = "0600";
      };
      "stash/session_store_key" = {
        owner = config.services.stash.user;
        inherit (config.services.stash) group;
        mode = "0600";
      };
      "stash/jwt_secret_key" = {
        owner = config.services.stash.user;
        inherit (config.services.stash) group;
        mode = "0600";
      };
    };

    environment.persistence = {
      "/persist".directories = [
        {
          directory = config.services.stash.dataDir;
          inherit (config.services.stash) user group;
          mode = "0750";
        }
      ];
    };
  };
}
