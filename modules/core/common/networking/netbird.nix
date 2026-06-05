{ config, ... }:
let
  interfaceName = "nb0";
  netbirdPort = 51820;
in
{
  services.netbird = {
    # TODO: configure based on role
    useRoutingFeatures = "server";
    clients.default = {
      port = netbirdPort;
      interface = interfaceName;
      # TODO: configure based on role
      ui.enable = false;
      autoStart = true;
      openFirewall = true;
    };
  };

  users.users.tydooo.extraGroups = [ "netbird-default" ];

  environment.persistence = {
    "/persist".directories = [
      {
        directory = config.services.netbird.clients.default.dir.state;
        user = config.services.netbird.clients.default.user.name;
        inherit (config.services.netbird.clients.default.user) group;
        mode = "0700";
      }
    ];
  };
}
