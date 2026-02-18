{
  lib,
  config,
  ...
}: {
  services.mealie = {
    enable = true;
    settings = {
      DB_ENGINE = "postgres";
      POSTGRES_URL_OVERRIDE = "postgresql://mealie:@/mealie?host=/run/postgresql";

      ALLOW_SIGNUP = "false";

      DATA_DIR = "/var/lib/mealie";

      TZ = "Europe/Amsterdam";

      SECURITY_MAX_LOGIN_ATTEMPTS = "3";
      SECURITY_USER_LOCKOUT_TIME = "24";

      OIDC_AUTH_ENABLED = true;
      OIDC_SIGNUP_ENABLED = true;
      OIDC_PROVIDER_NAME = "Pocket ID";
    };

    credentialsFile = config.sops.secrets."mealie-env".path;
  };

  sops.secrets."mealie-env" = {
    owner = "mealie";
    group = "mealie";
  };

  networking.firewall.allowedTCPPorts = [
    config.services.mealie.port
  ];

  users = {
    users.mealie = {
      home = config.services.mealie.settings.DATA_DIR;
      group = "mealie";
      isSystemUser = true;
    };
    groups.mealie = {};
  };

  systemd.services.mealie.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = lib.mkForce "mealie";
    Group = lib.mkForce "mealie";
  };

  environment.persistence."/persist".directories = [
    {
      directory = config.services.mealie.settings.DATA_DIR;
      user = "mealie";
      group = "mealie";
      mode = "0700";
    }
  ];

  services.postgresql = {
    ensureDatabases = ["mealie"];
    ensureUsers = [
      {
        name = "mealie";
        ensureDBOwnership = true;
      }
    ];
  };
}
