{config, ...}: let
  musicPath = "/mnt/user/music";
in {
  services.navidrome = {
    enable = true;
    settings = {
      Port = 4533;
      Address = "0.0.0.0";

      MusicFolder = musicPath;

      EnableInsightsCollector = false;
      EnableStarRating = false;
      EnableSharing = true;
    };
    openFirewall = true;
  };

  systemd.tmpfiles.rules = [
    "d /mnt/user/media/music 2775 root media - -"
  ];

  # Add the navidrome user to the media group to allow access to the library
  users.users.navidrome.extraGroups = ["media"];

  environment.persistence."/persist".directories = [
    {
      directory = "/var/lib/navidrome";
      inherit (config.services.navidrome) user group;
      mode = "0750";
    }
  ];
}
