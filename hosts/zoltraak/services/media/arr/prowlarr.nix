{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) singleton getExe;
in {
  systemd.services.prowlarr = {
    description = "Prowlarr";
    after = ["network.target" "proton0.service"];
    requires = ["proton0.service"];
    wantedBy = ["multi-user.target"];
    environment.HOME = "/var/empty";

    vpnConfinement = {
      enable = true;
      vpnNamespace = "proton0";
    };

    serviceConfig = {
      DynamicUser = true;
      ExecStart = "${getExe pkgs.prowlarr} -nobrowser -data=/var/lib/private/prowlarr";
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

  vpnNamespaces.proton0.portMappings = singleton {
    from = 9696;
    to = 9696;
  };

  # Allow prowlarr to access sonarr, radarr and flaresolverr over the VPN bridge
  networking.firewall.interfaces."proton0-br".allowedTCPPorts = [
    7878
    8989
    8191
  ];
}
