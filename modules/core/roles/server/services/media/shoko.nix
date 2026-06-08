{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.modules.services.media.shoko;
in
{
  options.modules.services.media.shoko = {
    enable = mkEnableOption "shoko";
  };

  config = mkIf cfg.enable {
    services.shoko = {
      enable = true;
      openFirewall = true;
    };

    users = {
      users.shoko = {
        group = "media";
        isSystemUser = true;
      };
    };

    systemd.services.shoko.serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = "shoko";
      Group = "media";
    };

    systemd.tmpfiles.rules = [
      "d /mnt/user/media/anime        2775 root  media - -"
      "d /mnt/user/media/import       2775 root  media - -"
      "d /mnt/user/media/import/anime 2775 shoko media - -"
    ];

    environment.persistence = {
      "/persist".directories = [
        {
          directory = "/var/lib/shoko";
          user = "shoko";
          group = "media";
          mode = "0750";
        }
      ];
    };
  };
}
