{
  lib,
  pkgs,
  ...
}:
let
  pathTank = "/mnt/disks/tank";
  pathGlass = "/mnt/disks/glass";
  pathCache = "/mnt/disks/cache";
  pathSlow = "/mnt/slow";

  # HELPERS

  mkZfs = device: {
    inherit device;
    fsType = "zfs";
  };

  mkMergerfs =
    {
      device,
      fsname,
      minfreespace,
    }:
    {
      inherit device;
      fsType = "fuse.mergerfs";
      options = [
        "category.create=epff"
        # epff only lets a branch be picked for new files if the parent
        # directory already exists there. By default, mkdir only creates
        # the directory on the single branch epff selects - so a plain
        # `cp -R` of a new directory (e.g. importing a season pack) would
        # succeed on the first branch, then fail with "Operation not
        # permitted" as soon as a later file in the same tree got routed
        # to a different branch by the create policy, since the parent
        # directory didn't exist there yet.
        # func.mkdir=all makes every mkdir create the directory on ALL
        # branches immediately, so it's always present everywhere before
        # any file create is attempted, and epff never has a branch to
        # reject.
        "func.mkdir=all"
        "defaults"
        "allow_other"
        "moveonenospc=1"
        "minfreespace=${minfreespace}"
        "func.getattr=newest"
        "fsname=${fsname}"
      ];
    };

  # ZFS MOUNTS

  mkTankDataset = dataset: {
    path = "${pathTank}/${dataset}";
    device = "tank/${dataset}";
  };

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
    (mkTankDataset "immich")
    (mkTankDataset "sauce")
    (mkTankDataset "media")
    (mkTankDataset "media/music")
    (mkTankDataset "paper")
  ];

  zfsFileSystems = lib.listToAttrs (
    map (
      { path, device }:
      lib.nameValuePair path (mkZfs device)
    ) zfsMounts
  );
in
{
  boot = {
    initrd.supportedFilesystems = [
      "btrfs"
      "zfs"
    ];
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

  fileSystems = zfsFileSystems // {
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
      minfreespace = "50G";
    };

    # Puts the cache drive in front of the slow disks. Don't use for
    # important data (instead, write to /mnt/disks/tank directly)!!!!!
    "/mnt/user" = mkMergerfs {
      device = "${pathCache}:${pathGlass}:${pathTank}";
      fsname = "user";
      minfreespace = "50G";
    };
  };
}
