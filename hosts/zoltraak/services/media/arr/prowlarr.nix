{
  pkgs,
  lib,
  ...
}: {
  systemd.services.prowlarr = {
    description = "Prowlarr";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    environment.HOME = "/var/empty";

    # TODO: setup vpnConfinement for Prowlarr

    serviceConfig = {
      DynamicUser = true;
      ExecStart = "${lib.getExe pkgs.prowlarr} -nobrowser -data=/var/lib/private/prowlarr";
      Restart = "on-failure";
      StateDirectory = "prowlarr";
      StateDirectoryMode = "750";
      MemoryDenyWriteExecute = false;
      SystemCallFilter = [
        "@system-service"
        "~@privileged"
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [9696];

  environment.persistence = {
    "/persist".directories = [
      {
        directory = "/var/lib/private/prowlarr";
        user = "nobody";
        group = "nogroup";
        mode = "0750";
      }
    ];
  };
}
