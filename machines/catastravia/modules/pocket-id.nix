{ config, pkgs, ... }: {
  clan.core.vars.generators."pocket-id-encryption-key" = {
    files.key = {
      secret = true;
      owner = "pocket-id";
      mode = "0400";
    };
    runtimeInputs = with pkgs; [
      coreutils
      openssl
    ];
    script = ''
      openssl rand -base64 32 > $out/key
    '';
  };

  services.pocket-id = {
    enable = true;
    settings = {
      TRUST_PROXY = true;
      ANALYTICS_DISABLED = true;
      APP_URL = "https://auth.tydooo.dev";
    };
    credentials = {
      ENCRYPTION_KEY = config.clan.core.vars.generators.pocket-id-encryption-key.files.key.path;
    };
  };

  services.caddy.virtualHosts."auth.tydooo.dev".extraConfig = ''
    reverse_proxy http://localhost:1411 {
      header_up X-Real-Ip {remote_host}
    }
  '';

  environment.persistence = {
    "/persist".directories = [
      {
        directory = config.services.pocket-id.dataDir;
        inherit (config.services.pocket-id) user group;
      }
    ];
  };

  clan.core.state.pocket-id = {
    folders = [ config.services.pocket-id.dataDir ];
    preBackupScript = ''
      systemctl stop pocket-id.service
    '';
    postBackupScript = ''
      systemctl start pocket-id.service
    '';
  };
}
