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

  systemd.services.navidrome = {
    # Ensure that the SMB share is mounted
    unitConfig.RequiresMountsFor = musicPath;
    serviceConfig.BindReadOnlyPaths = [musicPath];
  };

  # Add the navidrome user to the shared group to allow access to the library
  users.users.navidrome.extraGroups = ["shared"];

  environment.persistence."/persist".directories = [
    {
      directory = "/var/lib/navidrome";
      inherit (config.services.navidrome) user group;
      mode = "0700";
    }
  ];
}
