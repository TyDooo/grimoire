{
  config,
  pkgs,
  ...
}: let
  dataPath = "/var/lib/navidrome";
  musicPath = "/mnt/user/media/music";

  apple-music-plugin = pkgs.fetchurl {
    url = "https://github.com/navidrome/apple-music-plugin/releases/download/v0.1.1/apple-music.ndp";
    hash = "sha256-MFi/nC+sI33Q8QpoVCEK9a6xA+Yw8b/SlhNzGIY2DIc=";
  };

  audiomuseai-plugin = pkgs.fetchurl {
    url = "https://github.com/NeptuneHub/AudioMuse-AI-NV-plugin/releases/download/v7/audiomuseai.ndp";
    hash = "sha256-+rfCg8PrnfDhB75Q/HNE1lfFG8n0sBBB+y/cOMvaQ/g=";
  };
in {
  services.navidrome = {
    enable = true;
    settings = {
      Port = 4533;
      Address = "0.0.0.0";

      MusicFolder = musicPath;

      EnableInsightsCollector = false;
      EnableStarRating = false;
      PluginsEnabled = true;
      EnableSharing = true;

      Agents = "audiomuseai,apple-music,deezer,lastfm,listenbrainz";
    };
  };

  systemd.tmpfiles.rules = [
    "d ${musicPath} 2755 tydooo media - -"

    "d ${dataPath}/plugins 755 navidrome navidrome - -"
  ];

  systemd.services.navidrome = {
    serviceConfig.ExecStartPre = [
      "${pkgs.coreutils}/bin/cp -f ${apple-music-plugin} ${dataPath}/plugins/apple-music.ndp"
      "${pkgs.coreutils}/bin/cp -f ${audiomuseai-plugin} ${dataPath}/plugins/audiomuseai.ndp"
    ];
  };

  # Add the navidrome user to the media group to allow access to the library
  users.users.navidrome.extraGroups = ["media"];

  environment.persistence."/persist".directories = [
    {
      directory = dataPath;
      inherit (config.services.navidrome) user group;
      mode = "0750";
    }
  ];
}
