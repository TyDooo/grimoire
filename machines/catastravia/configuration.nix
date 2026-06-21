{
  imports = [
    ./modules
  ];

  boot = {
    initrd.systemd.enable = true;
    loader.grub = {
      enable = true;
      devices = [ "/dev/sda" ];
      efiSupport = true;
    };
  };

  system.nuke = {
    root = true; # Remove the root directory on each boot
    home = false; # I'm not confident enough to nuke the home directory yet
  };

  # New machine!
}
