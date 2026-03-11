{config, ...}: {
  vpnNamespaces.proton0 = {
    enable = true;
    wireguardConfigFile = config.sops.secrets."vpn/proton".path;
    accessibleFrom = ["127.0.0.1" "10.10.0.0/16"];
  };

  networking.firewall.allowedTCPPorts = [8182];

  sops.secrets."vpn/proton" = {};
}
