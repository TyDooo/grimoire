{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.modules.services.technitium;
in
{
  options.modules.services.technitium = {
    enable = mkEnableOption "technitium";
  };

  config = mkIf cfg.enable {
    services.technitium-dns-server = {
      enable = true;
      openFirewall = true;
    };

    # environment.persistence = {
    #   "/persist".directories = [
    #     {
    #       directory = config.services.jellyfin.dataDir;
    #       mode = "0700";
    #     }
    #   ];
    # };
  };
}
