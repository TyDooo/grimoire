{
  grimoire-utils,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.modules.services.mealie;

  database = {
    name = "mealie";
    user = "mealie";
  };
in
{
  options.modules.services.mealie = {
    enable = mkEnableOption "mealie";
  };

  config = mkIf cfg.enable {
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
        OIDC_CONFIGURATION_URL = "https://auth.driessen.family/.well-known/openid-configuration";
        OIDC_CLIENT_ID = "5abd9663-3a0d-47dc-accd-d3176fa1e612";

        BASE_URL = "https://mealie.driessen.family";
      };

      credentialsFile = config.clan.core.vars.generators."mealie".files."envfile".path;
    };

    clan.core.vars.generators."mealie" = grimoire-utils.mkEnvGenerator [
      "OIDC_CLIENT_SECRET"
    ];

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
      ensureDatabases = [ database.name ];
      ensureUsers = [
        {
          name = database.user;
          ensureDBOwnership = true;
        }
      ];
    };
  };
}
