{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.modules.services.media.stash;
in
{
  options.modules.services.media.stash = {
    enable = mkEnableOption "stash";
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev: {
        stashapp-tools = prev.python3Packages.buildPythonPackage rec {
          pname = "stashapp-tools";
          version = "0.2.59";
          format = "setuptools";

          src = prev.fetchPypi {
            inherit pname version;
            hash = "sha256-Y52YueWHp8C2FsnJ01YMBkz4O2z4d7RBeCswWGr8SjY=";
          };

          propagatedBuildInputs = with prev.python3Packages; [
            requests
          ];

          pythonImportsCheck = [ "stashapi" ];
        };

        # Python environment with required packages for Stash plugins
        stashPython = prev.python3.withPackages (
          ps: with ps; [
            final.stashapp-tools
            requests
          ]
        );
      })
    ];

    # NOTE: this is a custom stash module (modules/services/stashapp.nix)
    services.stashapp = {
      enable = true;
      openFirewall = true;
      pythonPackage = pkgs.stashPython;
      username = "TyDooo";
      passwordFile = config.clan.core.vars.generators.stash-secrets.files.password.path;
      sessionStoreKeyFile = config.clan.core.vars.generators.stash-secrets.files.sessionStoreKey.path;
      jwtSecretKeyFile = config.clan.core.vars.generators.stash-secrets.files.jwtSecretKey.path;
      mutableSettings = true;
      mutableScrapers = true;
      mutablePlugins = true;
      settings = {
        host = "0.0.0.0";
        port = 6969;
        stash = [
          {
            path = "/mnt/disks/tank/sauce/data";
            excludeimage = true;
          }
          {
            path = "/mnt/disks/tank/sauce/hentai";
            excludeimage = true;
          }
          {
            path = "/mnt/disks/tank/sauce/pictures";
            excludevideo = true;
          }
        ];
      };
    };

    clan.core.vars.generators.stash-secrets = {
      prompts.password-input = {
        description = "stash user password";
        type = "hidden";
        persist = false;
      };
      files = {
        password = {
          secret = true;
          owner = config.services.stash.user;
          inherit (config.services.stash) group;
          mode = "0600";
          restartUnits = [ "stashapp.service" ];
        };
        sessionStoreKey = {
          secret = true;
          owner = config.services.stash.user;
          inherit (config.services.stash) group;
          mode = "0600";
          restartUnits = [ "stashapp.service" ];
        };
        jwtSecretKey = {
          secret = true;
          owner = config.services.stash.user;
          inherit (config.services.stash) group;
          mode = "0600";
          restartUnits = [ "stashapp.service" ];
        };
      };
      runtimeInputs = [ pkgs.openssl ];
      script = ''
        cat $prompts/password-input > $out/password
        openssl rand -hex 32 > $out/sessionStoreKey
        openssl rand -hex 32 > $out/jwtSecretKey
      '';
    };

    environment.persistence = {
      "/persist".directories = [
        {
          directory = config.services.stash.dataDir;
          inherit (config.services.stash) user group;
          mode = "0750";
        }
      ];
    };
  };
}
