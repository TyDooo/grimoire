{config, ...}: {
  services.netbird.useRoutingFeatures = "server";
  services.netbird.clients.default = {
    port = 51820;
    interface = "wt0";
    ui.enable = false;
    autoStart = false;
  };

  users.users.tydooo.extraGroups = ["netbird-default"];

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
