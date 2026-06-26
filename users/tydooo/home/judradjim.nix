{ pkgs, ... }:
{
  imports = [
    ./programs
    ./desktop

    ./common.nix
  ];

  home.packages = with pkgs; [
    telegram-desktop
    protonvpn-gui
    thunderbird
    handbrake
    streamrip
    obsidian
    plexamp
    whipper
    logseq
    picard
    vlc
  ];
}
