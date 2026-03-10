{config, ...}: {
  services.bazarr = {
    enable = true;
    openFirewall = true;
  };

  # Add the Bazarr user to the media group to allow access to the library
  users.users.bazarr.extraGroups = ["media"];

  environment.persistence."/persist".directories = [
    {
      directory = config.services.bazarr.dataDir;
      inherit (config.services.bazarr) user group;
      mode = "0700";
    }
  ];
}
