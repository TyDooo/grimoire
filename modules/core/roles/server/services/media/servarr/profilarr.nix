{ config, lib, ... }:
let
  inherit (lib) mkIf;

  cfg = config.modules.services.media.servarr;
in
{
  config = mkIf cfg.enable {
    services.profilarr.enable = true;

    environment.persistence = {
      "/persist".directories = [
        {
          directory = config.services.profilarr.dataDir;
          mode = "0750";
        }
      ];
    };
  };
}
