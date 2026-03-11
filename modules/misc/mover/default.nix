{
  config,
  self',
  lib,
  ...
}: let
  cfg = config.services.mover;

  inherit (lib) mkIf mkOption mkEnableOption;
  inherit (lib.types) str int;
in {
  options.services.mover = {
    enable = mkEnableOption "Enable mover service to offload cache drive";
    cacheMount = mkOption {
      type = str;
      description = "Mount point for cache drive";
    };
    slowStorage = mkOption {
      type = str;
      description = "Mount point for slow storage pool (without cache drive)";
    };
    thresholdPercent = mkOption {
      type = int;
      description = "Threshold percentage of used space before running cache mover";
      default = 75;
    };
    targetPercent = mkOption {
      type = int;
      description = "Percentage of used space to target when running cache mover";
      default = 30;
    };
  };

  config = let
    moverEnv = {
      CACHE_PATH = cfg.cacheMount;
      BACKING_PATH = cfg.slowStorage;
      LOG_PATH = "/tmp/mover.log";
      AUTO_UPDATE = "false";
      THRESHOLD_PERCENTAGE = toString cfg.thresholdPercent;
      TARGET_PERCENTAGE = toString cfg.targetPercent;
      LOG_LEVEL = "INFO";
      MAX_WORKERS = "4";
      MAX_LOG_SIZE_MB = "100";
    };
  in
    mkIf cfg.enable {
      systemd.services.mover = {
        description = "Run the cache mover scripts every 6 hours";
        serviceConfig = {
          Type = "oneshot";
          User = "root"; # Run as root to preserve permissions
          ExecStart = "${self'.packages.mergerfs-cache-mover}/bin/mergerfs-cache-mover --console-log";
          RequiresMountsFor = "${cfg.cacheMount} ${cfg.slowStorage}";
        };
        environment = moverEnv;
      };

      systemd.timers.mover = {
        wantedBy = ["timers.target"];
        timerConfig = {
          description = "Run mover service every 6 hours";
          OnCalendar = "00/6:00";
          Unit = "mover.service";
          Persistent = true;
        };
      };
    };
}
