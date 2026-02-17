{config, ...}: {
  services.bazarr = {
    enable = true;
    openFirewall = true;
  };

  # Add the Bazarr user to the shared group to allow access to the library
  users.users.bazarr.extraGroups = ["shared"];

  environment.persistence."/persist".directories = [
    {
      directory = config.services.bazarr.dataDir;
      inherit (config.services.bazarr) user group;
      mode = "0700";
    }
  ];
}
