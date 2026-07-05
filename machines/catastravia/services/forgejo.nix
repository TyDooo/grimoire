{ config, ... }: {
  services.forgejo = {
    enable = true;
    lfs.enable = true;
    database.type = "sqlite3";
    settings = {
      server = {
        DOMAIN = "git.tydooo.dev";
        ROOT_URL = "https://git.tydooo.dev";
        HTTP_PORT = 3000;
        LANDING_PAGE = "/tydooo";
      };
      service = {
        DISABLE_REGISTRATION = true;
      };
    };
  };

  services.anubis.instances.forgejo = {
    enable = true;
    settings = {
      TARGET = "http://localhost:${toString config.services.forgejo.settings.server.HTTP_PORT}";
      SERVE_ROBOTS_TXT = true;
    };
  };

  services.caddy.virtualHosts."${toString config.services.forgejo.settings.server.DOMAIN}".extraConfig =
    ''
      reverse_proxy unix/${config.services.anubis.instances.forgejo.settings.BIND} {
        header_up X-Real-Ip {remote_host}
      }
    '';

  environment.persistence = {
    "/persist".directories = [
      {
        directory = config.services.forgejo.stateDir;
        inherit (config.services.forgejo) user group;
        mode = "0750";
      }
    ];
  };

  clan.core.state.forgejo = {
    folders = [ config.services.forgejo.stateDir ];
    preBackupScript = ''
      systemctl stop forgejo.service
    '';
    postBackupScript = ''
      systemctl start forgejo.service
    '';
  };
}
