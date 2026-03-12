{
  lib,
  pkgs,
  ...
}: let
  pathTank = "/mnt/disks/tank";
  pathGlass = "/mnt/disks/glass";
in {
  boot = {
    initrd.supportedFilesystems = ["btrfs" "zfs"];
    zfs.forceImportRoot = false;
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

    "/mnt/disks/cache" = {
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
      device = "/mnt/disks/cache:/mnt/slow"; # TODO: change to /mnt/disks/cache:${pathGlass}:${pathTank}?
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
