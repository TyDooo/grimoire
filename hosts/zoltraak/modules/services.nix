{
  modules.services = {
    copyparty.enable = true;
    frigate.enable = true;
    immich.enable = true;
    mealie.enable = true;
    rest-server.enable = true;

    download = {
      qbittorrent.enable = true;
      sabnzbd.enable = true;
    };

    media = {
      servarr.enable = true;
      jellyfin.enable = true;
      plex.enable = true;
      seerr.enable = true;
      shoko.enable = true;
      stash.enable = true;

      # Music
      audiomuse.enable = true;
      navidrome.enable = true;
    };

    database = {
      postgresql.enable = true;
    };
  };
}
