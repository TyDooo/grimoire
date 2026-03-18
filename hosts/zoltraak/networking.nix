{config, ...}: {
  networking = {
    firewall.enable = true;
    networkmanager.enable = false;
    hostId = "1f4d827b"; # IDK? For ZFS apparently...
    useDHCP = false;
  };

  systemd.network.enable = true;
  systemd.network = {
    netdevs = {
      "10-bond0" = {
        netdevConfig = {
          Kind = "bond";
          Name = "bond0";
        };
        bondConfig = {
          Mode = "802.3ad";
          TransmitHashPolicy = "layer3+4";
        };
      };
    };
    networks = {
      "30-enp2s0" = {
        matchConfig.Name = "enp2s0";
        networkConfig.Bond = "bond0";
        linkConfig.RequiredForOnline = "no";
      };
      "30-eno1" = {
        matchConfig.Name = "eno1";
        networkConfig.Bond = "bond0";
        linkConfig.RequiredForOnline = "no";
      };
      "40-bond0" = {
        matchConfig.Name = "bond0";
        linkConfig.RequiredForOnline = "routable";
        networkConfig.DHCP = "yes";
      };
    };
  };

  vpnNamespaces.proton0 = {
    enable = true;
    wireguardConfigFile = config.sops.secrets."vpn/proton".path;
    accessibleFrom = ["127.0.0.1" "10.10.0.0/16"];
    forward = {
      enable = true;
      qbittorrent = {
        enable = true;
        port = 8182;
      };
    };
  };

  sops.secrets."vpn/proton" = {};
}
