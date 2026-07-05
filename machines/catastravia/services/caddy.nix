{ config, ... }: {
  services.caddy = {
    enable = true;
    openFirewall = true;
  };

  environment.persistence = {
    "/persist".directories = [
      {
        directory = config.services.caddy.dataDir;
        inherit (config.services.caddy) user group;
        mode = "0770";
      }
    ];
  };

  # Allow caddy to access the anubis unix socket
  users.users.caddy.extraGroups = [ "anubis" ];
}
