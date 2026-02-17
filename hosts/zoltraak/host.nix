{
  self',
  pkgs,
  config,
  ...
}: {
  imports = [
    ./services
  ];

  networking = {
    networkmanager.enable = true;
  };

  environment.systemPackages = with pkgs; [
    wget
    helix
    git
    self'.packages.nvim
  ];

  boot = {
    initrd = {
      systemd.enable = true;
      supportedFilesystems = ["btrfs"];
    };

    loader.systemd-boot.enable = true;
  };

  programs.dconf.enable = true; # FIXME: needed?
  services.qemuGuest.enable = true; # FIXME: needed?

  modules.system.nuke = {
    root = true;
    home = false;
  };

  fileSystems = let
    sharedUid = toString config.users.users.shared.uid;
    sharedGid = toString config.users.groups.shared.gid;

    mntTowerSMB = share: {
      device = "//10.10.50.50/${share}";
      fsType = "cifs";
      options = [
        "credentials=${config.sops.secrets."smb-creds".path}"

        "uid=${sharedUid}"
        "gid=${sharedGid}"

        # Access Control:
        # 0770 = User(RWX) Group(RWX) Others(None)
        # 0660 = User(RW)  Group(RW)  Others(None)
        "dir_mode=0770"
        "file_mode=0660"

        # Prevent hangs if the server is down
        "x-systemd.automount,noauto,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s"
      ];
    };
  in {
    "/mnt/user/sauce" = mntTowerSMB "sauce";
    "/mnt/user/music" = mntTowerSMB "music";
    "/mnt/user/media" = mntTowerSMB "media";
  };

  sops.secrets."smb-creds" = {};

  users = {
    users.shared = {
      isSystemUser = true;
      group = "shared";
      uid = 2000;
    };
    users.tydooo.extraGroups = ["shared"];
    groups.shared.gid = 2000;
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
