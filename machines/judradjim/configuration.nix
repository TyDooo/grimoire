{ pkgs, lib, ... }:
{
  imports = [
    ./modules
  ];

  boot = {
    initrd.systemd.enable = true;
    loader.systemd-boot.enable = true;
  };

  system.nuke = {
    root = true; # Remove the root directory on each boot
    home = lib.mkForce false; # Not supported on this machine
  };

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    vscodium
    feishin # Subsonic compatible music player
    whipper # Music CD ripper
    picard # Music tagger
    kitty
  ];
}
