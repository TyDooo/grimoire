{config, ...}: {
  services.pocket-id = {
    enable = true;
    settings = {
      TRUST_PROXY = true;
      APP_URL = "https://pocket-id.driessen.family";
      ANALYTICS_DISABLED = true;
      DB_CONNECTION_STRING = "postgresql://pocket-id:@/pocket-id?host=/run/postgresql";
      UI_CONFIG_DISABLED = true;
      PORT = 1411;
    };
    credentials = {
      ENCRYPTION_KEY = config.sops.secrets."pocket-id/encryption_key".path;
    };
  };

  sops.secrets."pocket-id/encryption_key" = {
    owner = config.services.pocket-id.user;
    inherit (config.services.pocket-id) group;
  };

  environment.persistence."/persist".directories = [
    {
      directory = config.services.pocket-id.dataDir;
      inherit (config.services.pocket-id) user group;
      mode = "0700";
    }
  ];

  services.postgresql = {
    enable = true;
    ensureUsers = [
      {
        name = "pocket-id";
        ensureDBOwnership = true;
      }
    ];
    ensureDatabases = ["pocket-id"];
  };

  networking.firewall.allowedTCPPorts = [
    config.services.pocket-id.settings.PORT
  ];
}
