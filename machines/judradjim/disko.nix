{
  disko.devices = {
    disk.nvme0 = {
      device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_500GB_S4EVNF0M618709Y";
      type = "disk";

      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };

          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [
                "-L"
                "nixos"
                "-f"
              ];
              postCreateHook = ''
                MNTPOINT=$(mktemp -d)
                mount -t btrfs "$device" "$MNTPOINT"
                trap 'umount $MNTPOINT; rm -d $MNTPOINT' EXIT
                btrfs subvolume snapshot -r $MNTPOINT/root $MNTPOINT/root-blank
              '';
              mountOptions = [
                "compress=zstd"
                "noatime"
                "discard=async"
              ];
              subvolumes = {
                "/root" = {
                  mountpoint = "/";
                  mountOptions = [
                    "subvol=root"
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "subvol=nix"
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "/persist" = {
                  mountpoint = "/persist";
                  mountOptions = [
                    "subvol=persist"
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "/log" = {
                  mountpoint = "/var/log";
                  mountOptions = [
                    "subvol=log"
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "/swap" = {
                  mountpoint = "/swap";
                  swap.swapfile.size = "8G";
                };
              };
            };
          };
        };
      };
    };

    disk.nvme1 = {
      device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_1TB_S467NX0M718634R";
      type = "disk";

      content = {
        type = "gpt";
        partitions.data = {
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ];
            mountOptions = [
              "compress=zstd"
              "noatime"
              "discard=async"
            ];
            subvolumes = {
              "/home" = {
                mountpoint = "/home";
                mountOptions = [
                  "subvol=home"
                  "compress=zstd"
                  "noatime"
                ];
              };
              "/games" = {
                mountpoint = "/mnt/games";
                mountOptions = [
                  "subvol=games"
                  "compress=zstd"
                  "noatime"
                ];
              };
            };
          };
        };
      };
    };

    disk.sata0 = {
      device = "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_500GB_S3R3NF1JA65632X";
      type = "disk";

      content = {
        type = "gpt";
        partitions.data = {
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = [
              "-L"
              "music"
              "-f"
            ];
            mountOptions = [
              "compress=zstd"
              "noatime"
              "discard=async"
            ];
            subvolumes = {
              "/music" = {
                mountpoint = "/mnt/music";
              };
            };
          };
        };
      };
    };
  };

  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;
}
