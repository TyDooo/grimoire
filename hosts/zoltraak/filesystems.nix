{
  boot = {
    initrd.supportedFilesystems = ["btrfs" "zfs"];
    zfs.forceImportRoot = false;
  };

  fileSystems = {
    "/mnt/tank" = {
      device = "tank";
      fsType = "zfs";
    };

    "/mnt/glass" = {
      device = "glass";
      fsType = "zfs";
    };

    "/mnt/cache" = {
      device = "UUID=f1209f58-c197-41f6-b921-0532da5dea59";
      fsType = "btrfs";
    };

    "/mnt/frigate" = {
      device = "UUID=cf17ec35-d534-4467-b597-d94fc04747f0";
      fsType = "ext4";
    };
  };
}
