{ config, pkgs, ... }:
let
  dataPath = "/var/lib/navidrome";
  musicPath = "/mnt/user/media/music";
in
{
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

      Plugins.Enabled = true;

      Agents = "audiomuseai,apple-music,deezer,lastfm,listenbrainz";
    };

    plugins = with pkgs.navidromePlugins; [
      apple-music
      audiomuseai
    ];
  };

  systemd.tmpfiles.rules = [
    "d ${musicPath} 2755 tydooo media - -"
  ];

  systemd.services.navidrome = {
    serviceConfig.RequiresMountsFor = "${musicPath}";
  };

  # Add the navidrome user to the media group to allow access to the library
  users.users.navidrome.extraGroups = [ "media" ];

  environment.persistence."/persist".directories = [
    {
      directory = dataPath;
      inherit (config.services.navidrome) user group;
      mode = "0750";
    }
  ];

  clan.core.state.navidrome = {
    folders = [ dataPath ];
    preBackupScript = ''
      systemctl stop navidrome.service
    '';
    postBackupScript = ''
      systemctl start navidrome.service
    '';
  };
}
