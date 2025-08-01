{pkgs, ...}: {
  imports = [
    ./common.nix

    ./desktop
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
    vscode
    vlc
  ];
}
