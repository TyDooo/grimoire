{
  self',
  pkgs,
  ...
}: {
  imports = [
    ./services

    ./filesystems.nix
    ./networking.nix
  ];

  environment.systemPackages = with pkgs; [
    wget
    helix
    btop
    git
    rsync
    self'.packages.nvim
  ];

  boot = {
    initrd.systemd.enable = true;
    loader.systemd-boot.enable = true;
  };

  programs.dconf.enable = true; # FIXME: needed?

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-ocl
      intel-media-driver
      intel-compute-runtime-legacy1
    ];
  };

  users = {
    users.tydooo.extraGroups = ["media" "backup"];
    groups = {
      media = {};
      backup = {};
    };
  };

  systemd.services.systemd-tmpfiles-setup = {
    after = ["mnt-user.mount"];
    requires = ["mnt-user.mount"];
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/private    0700 root root   - -"
    "d /mnt/user/downloads 0775 root media  - -"

    "d /mnt/disks/tank/backup 2775 root backup - -"
    "d /mnt/disks/tank/backup/home_assistant 2775 root backup - -"
    "d /mnt/disks/tank/backup/proxmox        2775 root backup - -"
  ];

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
  system.stateVersion = "25.11"; # Did you read the comment?
}
