{
  config,
  self,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.modules.services.media.navidrome;

  dataPath = "/var/lib/navidrome";
  musicPath = "/mnt/user/media/music";
in
{
  options.modules.services.media.navidrome = {
    enable = mkEnableOption "navidrome";
  };

  config = mkIf cfg.enable {
    services.navidrome = {
      enable = true;
      # TODO: Change back to nixpkgs version once v0.62.0 is packaged
      package = self.packages.x86_64-linux.navidrome;

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
  };
}
