{
  lib,
  pkgs,
  ...
}: let
  pathTank = "/mnt/disks/tank";
  pathGlass = "/mnt/disks/glass";
  pathCache = "/mnt/disks/cache";
  pathSlow = "/mnt/slow";
in {
  boot = {
    initrd.supportedFilesystems = ["btrfs" "zfs"];
    zfs.forceImportRoot = false;
  };

  system.nuke = {
    root = true; # Remove the root directory on each boot
    home = false;
  };

  services.mover = {
    enable = true;
    cacheMount = pathCache;
    slowStorage = pathSlow;
    thresholdPercent = 70;
    targetPercent = 30;
  };

  programs.fuse.userAllowOther = lib.mkForce true;

  environment.systemPackages = with pkgs; [
    mergerfs
    mergerfs-tools
  ];

  fileSystems = {
    "${pathTank}" = {
      device = "tank";
      fsType = "zfs";
    };

    "${pathGlass}" = {
      device = "glass";
      fsType = "zfs";
    };

    # Had some issues with ZFS automount, so mountpoint=legacy it is
    "${pathTank}/immich" = {
      device = "tank/immich";
      fsType = "zfs";
    };

    "${pathCache}" = {
      device = "UUID=f1209f58-c197-41f6-b921-0532da5dea59";
      fsType = "btrfs";
    };

    "/mnt/disks/frigate" = {
      device = "UUID=cf17ec35-d534-4467-b597-d94fc04747f0";
      fsType = "ext4";
    };

    "/mnt/slow" = {
      # Merges the spinning rust disks into a single target. Mainly used
      # as a target for the mover. Don't use for important data (instead,
      # write to /mnt/disks/tank directly)!!!!!
      device = "${pathGlass}:${pathTank}";
      fsType = "fuse.mergerfs";
      options = [
        "category.create=epff"
        "defaults"
        "allow_other"
        "moveonenospc=1"
        "minfreespace=100G"
        "func.getattr=newest"
        "fsname=mergerfs_slow"
      ];
    };

    "/mnt/user" = {
      # Puts the cache drive in front of the slow disks. Don't use for
      # important data (instead, write to /mnt/disks/tank directly)!!!!!
      device = "${pathCache}:${pathSlow}"; # TODO: change to ${pathCache}:${pathGlass}:${pathTank}?
      fsType = "fuse.mergerfs";
      options = [
        "category.create=epff"
        "defaults"
        "allow_other"
        "moveonenospc=1"
        "minfreespace=50G"
        "func.getattr=newest"
        "fsname=user"
      ];
    };
  };
}
