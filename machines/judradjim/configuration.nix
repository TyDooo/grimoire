{ lib, ... }: {
  boot = {
    initrd.systemd.enable = true;
    loader.systemd-boot.enable = true;
  };

  system.nuke = {
    root = true; # Remove the root directory on each boot
    home = lib.mkForce false; # Not supported on this machine
  };
}
