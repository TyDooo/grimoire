{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkOption;

  cfg = config.services.profilarr;
in
{
  options.services.profilarr = {
    enable = mkEnableOption "Enable profilarr service";
    port = mkOption {
      type = lib.types.number;
      default = 6868;
    };
    dataDir = mkOption {
      type = lib.types.path;
      default = "/var/lib/profilarr";
      description = "Directory for profilarr config volume.";
    };
    timeZone = mkOption {
      type = lib.types.str;
      default = config.time.timeZone;
      description = "Timezone for profilarr.";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.profilarr = {
      image = "ghcr.io/dictionarry-hub/profilarr:latest";
      ports = [ "${toString cfg.port}:6868" ];
      environment = {
        TZ = cfg.timeZone;
      };
      volumes = [
        "${cfg.dataDir}:/config"
      ];
    };
  };
}
