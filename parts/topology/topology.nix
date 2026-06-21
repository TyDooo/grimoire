{ config, ... }:
let
  inherit (config.lib.topology)
    mkInternet
    mkSwitch
    mkRouter
    mkConnection
    ;
in
{
  networks.net-management = {
    name = "Management Network";
    cidrv4 = "10.10.1.1/24";
    cidrv6 = "2001:1c05:3a0d:f000::1/64";
  };

  networks.net-trusted = {
    name = "Trusted Network";
    cidrv4 = "10.10.10.1/24";
    cidrv6 = "2001:1c05:3a0d:f001::1/64";
  };

  networks.net-iot = {
    name = "IoT Network";
    cidrv4 = "10.10.20.1/24";
  };

  networks.net-guest = {
    name = "Guest Network";
    cidrv4 = "10.10.30.1/24";
  };

  networks.net-media = {
    name = "Media Network";
    cidrv4 = "10.10.40.1/24";
  };

  networks.net-server = {
    name = "Server Network";
    cidrv4 = "10.10.50.1/24";
  };

  networks.net-surveillance = {
    name = "Surveillance Network";
    cidrv4 = "10.10.60.1/24";
  };

  nodes.internet = mkInternet {
    connections = [
      (mkConnection "unifi-gateway" "wan1")
      (mkConnection "catastravia" "enp1s0")
    ];
  };

  nodes.unifi-gateway = mkRouter "Unifi Gateway" {
    info = "Unifi gateway";
    image = ./images/UCG-Max.png;
    interfaceGroups = [
      [ "wan1" ]
      [
        "lan4"
        "lan3"
        "lan2"
        "lan1"
      ]
    ];
    connections.lan1 = mkConnection "switch-bijkeuken" "port8";
    connections.lan4 = mkConnection "switch-meterkast" "port16";
  };

  nodes.switch-meterkast = mkSwitch "Switch Meterkast" {
    image = ./images/USW-Lite-16-PoE.png;
    interfaceGroups = [
      [
        # "port1"
        # "port2"
        "port3"
        "port4"
        # "port5"
        # "port6"
        # "port7"
        # "port8"
        # "port9"
        # "port10"
        # "port11"
        # "port12"
        # "port13"
        # "port14"
        # "port15"
        "port16"
      ]
    ];
    connections.port3 = mkConnection "zoltraak" "eno1";
    connections.port4 = mkConnection "zoltraak" "enp2s0";
  };

  nodes.switch-bijkeuken = mkSwitch "Switch Bijkeuken" {
    image = ./images/USW-Lite-8-PoE.png;
    interfaceGroups = [
      [
        # "port1"
        # "port2"
        # "port3"
        # "port4"
        # "port5"
        # "port6"
        # "port7"
        "port8"
      ]
    ];
  };
}
