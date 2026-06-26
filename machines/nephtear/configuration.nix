{ ... }: {
  imports = [
    ./modules
  ];

  boot = {
    # Quite boot
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [ "quiet" ];

    initrd.systemd.enable = true;
    loader.systemd-boot.enable = true;
    plymouth.enable = true;
  };

  system.nuke = {
    root = true; # Remove the root directory on each boot
    home = false; # I'm not confident enough to nuke the home directory yet
  };

  environment.persistence = {
    "/persist".directories = [
      "/var/lib/bluetooth"
    ];
  };

  system.stateVersion = "26.05";
}
