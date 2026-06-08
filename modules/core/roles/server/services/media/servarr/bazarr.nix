{ config, lib, ... }:
let
  inherit (lib) mkIf;

  cfg = config.modules.services.media.servarr;
in
{
  config = mkIf cfg.enable {
    services.bazarr = {
      enable = true;
      group = "media";
      openFirewall = true;
    };

    environment.persistence."/persist".directories = [
      {
        directory = config.services.bazarr.dataDir;
        inherit (config.services.bazarr) user group;
        mode = "0750";
      }
    ];
  };
}
