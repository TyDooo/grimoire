{
  lib,
  pkgs,
  ...
}: let
  pathTank = "/mnt/disks/tank";
  pathGlass = "/mnt/disks/glass";
  pathCache = "/mnt/disks/cache";
  pathSlow = "/mnt/slow";

  # HELPERS

  mkZfs = device: {
    inherit device;
    fsType = "zfs";
  };

  mkMergerfs = {
    device,
    fsname,
    minfreespace,
  }: {
    inherit device;
    fsType = "fuse.mergerfs";
    options = [
      "category.create=epff"
      "defaults"
      "allow_other"
      "moveonenospc=1"
      "minfreespace=${minfreespace}"
      "func.getattr=newest"
      "fsname=${fsname}"
    ];
  };

  # ZFS MOUNTS

  zfsMounts = [
    {
      path = pathTank;
      device = "tank";
    }
    {
      path = pathGlass;
      device = "glass";
    }

    # Had some issues with ZFS automount where some datasets would
    # show up as mounted, but the data inside of the dataset was
    # not accessible. Using the "mountpoint=legacy" option works
    # around this issue. This also makes it a bit more declerative.
    {
      path = "${pathTank}/immich";
      device = "tank/immich";
    }
    {
      path = "${pathTank}/sauce";
      device = "tank/sauce";
    }
  ];

  zfsFileSystems = lib.listToAttrs (
    map ({
      path,
      device,
    }:
      lib.nameValuePair path (mkZfs device))
    zfsMounts
  );
in {
  boot = {
    initrd.supportedFilesystems = ["btrfs" "zfs"];
    zfs.forceImportRoot = false;
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

  fileSystems =
    zfsFileSystems
    // {
      "${pathCache}" = {
        device = "UUID=f1209f58-c197-41f6-b921-0532da5dea59";
        fsType = "btrfs";
      };

      "/mnt/disks/frigate" = {
        device = "UUID=cf17ec35-d534-4467-b597-d94fc04747f0";
        fsType = "ext4";
      };

      # Merges the spinning rust disks into a single target. Mainly used
      # as a target for the mover. Don't use for important data (instead,
      # write to /mnt/disks/tank directly)!!!!!
      "/mnt/slow" = mkMergerfs {
        device = "${pathGlass}:${pathTank}";
        fsname = "mergerfs_slow";
        minfreespace = "100G";
      };

      # Puts the cache drive in front of the slow disks. Don't use for
      # important data (instead, write to /mnt/disks/tank directly)!!!!!
      # TODO: change to ${pathCache}:${pathGlass}:${pathTank}?
      "/mnt/user" = mkMergerfs {
        device = "${pathCache}:${pathSlow}";
        fsname = "user";
        minfreespace = "50G";
      };
    };
}
