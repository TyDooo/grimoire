{
  imports = [
    ./arr

    ./jellyfin.nix
    ./navidrome.nix
    ./plex.nix
    ./seerr.nix
    ./shoko.nix
  ];

  systemd.tmpfiles.rules = [
    "d /mnt/user/media 2770 root media - -"
  ];
}
