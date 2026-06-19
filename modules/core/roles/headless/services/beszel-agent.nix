{ grimoire-utils, config, ... }:
{
  services.beszel.agent = {
    enable = true;
    smartmon.enable = true;
    environmentFile = config.clan.core.vars.generators."beszel-agent".files."envfile".path;
    environment = {
      HUB_URL = "http://100.99.158.193:8090";
    };
  };

  clan.core.vars.generators."beszel-agent" = grimoire-utils.mkEnvGenerator [
    "KEY"
    "TOKEN"
  ];
}
