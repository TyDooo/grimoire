{ config, ... }:
{
  services.profilarr.enable = true;

  environment.persistence = {
    "/persist".directories = [
      {
        directory = config.services.profilarr.dataDir;
        mode = "0750";
      }
    ];
  };
}
