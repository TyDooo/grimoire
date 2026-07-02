{
  _class = "clan.service";
  manifest.name = "shoko";
  manifest.description = "Shoko anime manager";
  manifest.readme = "Shoko anime manager";
  manifest.categories = [ "Media" ];
  manifest.exports.out = [ "endpoints" ];

  roles.default = {
    description = "Sets up shoko server with caddy reverse proxy";
    interface =
      { lib, meta, ... }:
      {
        options = {
          host = lib.mkOption {
            type = lib.types.str;
            default = "shoko.${meta.domain}";
            description = "Host serving the shoko instance";
            example = "party.example.com";
          };
        };
      };

    perInstance =
      {
        settings,
        mkExports,
        ...
      }:
      {

        exports = mkExports { endpoints.hosts = [ settings.host ]; };

        nixosModule =
          { lib, ... }:
          {
            config = {
              services.caddy = {
                enable = true;
                virtualHosts."${settings.host}".extraConfig = "reverse_proxy 127.0.0.1:8111";
              };

              services.shoko = {
                enable = true;
                openFirewall = true;
              };

              users = {
                users.shoko = {
                  group = "media";
                  isSystemUser = true;
                  extraGroups = [ "stash" ];
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

              # Register backup location
              clan.core.state."shoko" = {
                folders = [ "/var/lib/shoko" ];
                preBackupScript = ''
                  systemctl stop shoko.service
                '';
                postBackupScript = ''
                  systemctl start shoko.service
                '';
              };

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
          };
      };
  };
}
