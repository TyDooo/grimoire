{
  config,
  lib,
  ...
}: let
  cfg = config.services.nfs-exports;

  inherit (lib) types;

  shareType = types.submodule {
    options = {
      source = lib.mkOption {
        type = types.str;
        description = "Source path to bind mount into the export tree.";
      };
      options = lib.mkOption {
        type = types.str;
        default = "rw,nohide";
        description = "NFS export options for this share.";
      };
    };
  };

  clientExportStr = clients: opts:
    lib.concatMapStringsSep " " (client: "${client}(${opts})") clients;

  exportLines = lib.concatStringsSep "\n" (
    ["${cfg.basePath}  ${clientExportStr cfg.clients "rw,fsid=0"}"] # Create the root share
    ++ lib.mapAttrsToList (
      name: share: "${cfg.basePath}/${name}  ${clientExportStr cfg.clients share.options}"
    )
    cfg.shares
  );
in {
  options.services.nfs-exports = {
    enable = lib.mkEnableOption "NFS server with auto-generated bind mounts and exports";

    basePath = lib.mkOption {
      type = types.str;
      default = "/export";
      description = "Base directory for the NFS export tree.";
    };

    clients = lib.mkOption {
      type = types.listOf types.str;
      example = ["192.168.1.100" "192.168.1.0/24"];
      description = "Client IPs or subnets allowed to mount the exports.";
    };

    shares = lib.mkOption {
      type = types.attrsOf shareType;
      default = {};
      example = {
        music.source = "/mnt/user/music";
        data.source = "/mnt/data";
      };
      description = "Attribute set of shares. Keys become subdirectory names under basePath.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Ensure that the base path exists with the correct permissions
    systemd.tmpfiles.rules = [
      "d ${cfg.basePath} 0755 nobody nogroup - -"
    ];

    # Create a bind mount under the base path for each NFS share
    fileSystems =
      lib.mapAttrs' (
        name: share:
          lib.nameValuePair "${cfg.basePath}/${name}" {
            device = share.source;
            options = ["bind"];
          }
      )
      cfg.shares;

    services.nfs = {
      server = {
        enable = true;
        exports = ''
          ${exportLines}
        '';
      };
      # Disable all NFS versions except for version 4
      settings.nfsd = {
        UDP = "off";
        vers2 = "off";
        vers3 = "off";
      };
    };

    environment.persistence = {
      "/persist".directories = [
        {directory = "/var/lib/nfs";}
        {
          directory = cfg.basePath;
          user = "nobody";
          group = "nogroup";
          mode = "0755";
        }
      ];
    };

    networking.firewall.allowedTCPPorts = [111 2049];
    networking.firewall.allowedUDPPorts = [111 2049];
  };
}
