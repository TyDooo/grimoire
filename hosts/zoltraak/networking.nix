{
  config,
  pkgs,
  ...
}: {
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
  };

  # Based on https://github.com/ImUrX/nixfiles/blob/b07d94b2a7dec5c5d8c93d60b706434db3514554/modules/wg-pnp.nix

  systemd.timers.proton0-port-forwarding = {
    wantedBy = ["timers.target"];
    after = ["proton0.service"];
    timerConfig = {
      # Run every 45s to ensure the port doesn't expire
      OnBootSec = "45s";
      OnUnitActiveSec = "45s";
      Unit = "proton0-port-forwarding.service";
    };
  };

  systemd.services.proton0-port-forwarding = {
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
    bindsTo = ["proton0.service"];
    after = ["proton0.service"];

    vpnConfinement = {
      enable = true;
      vpnNamespace = "proton0";
    };

    path = with pkgs; [wget libnatpmp ripgrep iptables];

    script = ''
      set -u

      port_file="/tmp/proton0-port"
      old_port="$(cat "$port_file" 2>/dev/null || echo "")"

      # Renew the NAT-PMP mapping for both protocols. We assume that the TCP and UDP ports are the same.
      result="$(natpmpc -a 1 0 udp 60 -g 10.2.0.1)"
      result="$(natpmpc -a 1 0 tcp 60 -g 10.2.0.1)"
      echo "$result"

      new_port="$(echo "$result" | rg --only-matching --replace '$1' 'Mapped public port (\d+) protocol')"
      echo "$new_port" > "$port_file"
      if [ "$new_port" = "$old_port" ]; then
        echo "Port unchanged ($new_port), nothing to do."
        exit 0
      fi
      echo "Mapped port $new_port, old was ''${old_port:-none}."

      # Open new port in iptables
      for protocol in udp tcp; do
        if iptables -C INPUT -p "$protocol" --dport "$new_port" -j ACCEPT -i proton00 2>/dev/null; then
          echo "Port $new_port/$protocol already open."
        else
          echo "Opening port $new_port/$protocol."
          iptables -I INPUT -p "$protocol" --dport "$new_port" -j ACCEPT -i proton00
        fi
      done

      echo "Updating qBittorrent listen port to $new_port..."
      wget -O- -nv --retry-connrefused \
        --post-data "json={\"listen_port\":$new_port,\"current_network_interface\":\"proton00\",\"random_port\":false,\"upnp\":false}" \
        http://127.0.0.1:8182/api/v2/app/setPreferences
      echo ""

      # Close old port if it changed
      if [ -n "$old_port" ]; then
        for proto in udp tcp; do
          if iptables -C INPUT -p "$proto" --dport "$old_port" -j ACCEPT -i proton00 2>/dev/null; then
            echo "Closing old port $old_port/$proto."
            iptables -D INPUT -p "$proto" --dport "$old_port" -j ACCEPT -i proton00
          fi
        done
      fi
    '';
  };

  # TODO: set qbittorrent port to 0 if the VPN interface goes down

  sops.secrets."vpn/proton" = {};
}
