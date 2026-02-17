{
  config,
  lib,
  ...
}: let
  prowlarrUserGroup = "prowlarr";
in {
  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };

  users = {
    users.prowlarr = {
      home = config.services.prowlarr.dataDir;
      group = prowlarrUserGroup;
      isSystemUser = true;
    };
    groups.prowlarr = {};
  };

  # Disable DynamicUser
  systemd.services.prowlarr.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = lib.mkForce prowlarrUserGroup;
    Group = lib.mkForce prowlarrUserGroup;
  };

  environment.persistence = {
    "/persist".directories = [
      {
        directory = config.services.prowlarr.dataDir;
        user = prowlarrUserGroup;
        group = prowlarrUserGroup;
        mode = "0700";
      }
    ];
  };
}
