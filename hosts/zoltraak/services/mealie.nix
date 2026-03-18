{config, ...}: let
  database = {
    name = "mealie";
    user = "mealie";
  };
in {
  services.mealie = {
    enable = true;
    settings = {
      DB_ENGINE = "postgres";
      POSTGRES_URL_OVERRIDE = "postgresql://${database.user}:@/${database.name}?host=/run/postgresql";

      ALLOW_SIGNUP = "false";

      TZ = "Europe/Amsterdam";

      SECURITY_MAX_LOGIN_ATTEMPTS = "3";
      SECURITY_USER_LOCKOUT_TIME = "24";

      OIDC_AUTH_ENABLED = "false";
      OIDC_SIGNUP_ENABLED = "true";
      OIDC_PROVIDER_NAME = "Pocket ID";
    };

    credentialsFile = config.sops.secrets."mealie-env".path;
  };

  sops.secrets."mealie-env" = {};

  networking.firewall.allowedTCPPorts = [
    config.services.mealie.port
  ];

  environment.persistence = {
    "/persist".directories = [
      {
        directory = "/var/lib/private/mealie";
        user = "nobody";
        group = "nogroup";
        mode = "0750";
      }
    ];
  };

  services.postgresql = {
    ensureDatabases = [database.name];
    ensureUsers = [
      {
        name = database.user;
        ensureDBOwnership = true;
      }
    ];
  };
}
