{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.modules.services.database.postgresql;
in
{
  options.modules.services.database.postgresql = {
    enable = mkEnableOption "postgresql";
  };

  config = mkIf cfg.enable {
    services.postgresql.enable = true;

    environment.persistence."/persist".directories = [
      {
        directory = "/var/lib/postgresql";
        user = "postgres";
        group = "postgres";
        mode = "0700";
      }
    ];
  };
}
