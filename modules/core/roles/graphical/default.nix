{
  imports = [
    ./fonts.nix
    ./pipewire.nix
  ];

  boot = {
    # Quite boot
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [ "quiet" ];

    plymouth.enable = true;
  };
}
