{
  config,
  lib,
  ...
}: {
  networking = {
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
    hostId = "1f4d827b";
  };

  vpnNamespaces.proton0 = {
    enable = true;
    wireguardConfigFile = config.sops.secrets."vpn/proton".path;
    accessibleFrom = ["127.0.0.1" "10.10.0.0/16"];
  };

  sops.secrets."vpn/proton" = {};
}
