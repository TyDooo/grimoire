{config, ...}: let
  cfg = config.services.immich;

  # Write directly to tank/immich ZFS dataset
  mediaLocation = "/mnt/disks/tank/immich";
in {
  services.immich = {
    enable = true;
    host = "0.0.0.0";
    inherit mediaLocation;
    settings = null;

    redis.enable = true;
    machine-learning.enable = true;
    database = {
      enable = true;
      createDB = true;
    };
    accelerationDevices = ["/dev/dri/renderD128"];
  };

  systemd.tmpfiles.rules = [
    "d ${mediaLocation} 755 ${cfg.user} ${cfg.group} - -"
  ];

  environment.persistence = {
    "/persist".directories = [
      {
        directory = "/var/lib/immich";
        inherit (cfg) user group;
        mode = "0750";
      }
    ];
  };
}
