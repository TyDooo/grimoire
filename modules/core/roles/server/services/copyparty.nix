{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (lib) singleton mkIf mkEnableOption;

  cfg = config.modules.services.copyparty;
in
{
  imports = [ inputs.copyparty.nixosModules.default ];

  options.modules.services.copyparty = {
    enable = mkEnableOption "copyparty";
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.copyparty.overlays.default ];

    services.copyparty = {
      enable = true;
      settings = {
        # https://copyparty.eu/helptext.txt

        i = "0.0.0.0";
        p = singleton 3923;

        localtime = true;
      };
      accounts.tydooo.passwordFile =
        config.clan.core.vars.generators.copyparty-user-password.files.password-tydooo.path;
      volumes = {
        "/" = {
          path = "/mnt/disks/tank/files";
          access.A = "tydooo";
          flags = {
            scan = 60;
            fk = 4;
          };
        };
        "/media/walls" = {
          path = "/mnt/disks/tank/files/walls";
          access = {
            r = "*";
            A = [ "tydooo" ];
          };
          flags = {
            scan = 30;
            fk = 4;
          };
        };
        "/media/music" = {
          path = "/mnt/user/media/music";
          access = {
            r = "*";
            A = [ "tydooo" ];
          };
          flags = {
            scan = 30;
            fk = 4;
          };
        };
        "/media/sauce" = {
          path = "/mnt/user/sauce";
          access = {
            A = [ "tydooo" ];
          };
          flags = {
            scan = 30;
            fk = 4;
          };
        };
        "/media/reaction" = {
          path = "/mnt/disks/tank/files/reaction";
          access = {
            r = "*";
            A = [ "tydooo" ];
          };
          flags = {
            scan = 30;
            fk = 4;
          };
        };
      };
    };

    users.users.copyparty.extraGroups = [ "media" ];

    systemd.tmpfiles.rules = [
      "d /mnt/disks/tank/files 0770 copyparty copyparty - -"
    ];

    environment.persistence = {
      "/persist".directories = [
        {
          directory = "/var/lib/copyparty";
          inherit (config.services.copyparty) user group;
          mode = "0750";
        }
      ];
    };

    clan.core.vars.generators.copyparty-user-password = {
      prompts.password-input-tydooo = {
        description = "copyparty tydooo user password";
        type = "hidden";
        persist = false;
      };
      files.password-tydooo = {
        secret = true;
        owner = "copyparty";
        group = "copyparty";
        mode = "0600";
        restartUnits = [ "copyparty.service" ];
      };
      script = ''
        cat $prompts/password-input-tydooo > $out/password-tydooo
      '';
    };
  };
}
