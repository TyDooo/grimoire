{ config, lib, ... }:
let
  inherit (lib) mkIf;

  cfg = config.modules.services.media.servarr;
in
{
  config = mkIf cfg.enable {
    services.flaresolverr.enable = true;
  };
}
