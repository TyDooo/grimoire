{
  inputs,
  ...
}:
let
  inherit (self) outputs;
  inherit (inputs) self;

  modulePath = ./modules;

  coreModules = modulePath + /core;

  common = coreModules + /common;

  # ROLES
  server = coreModules + /roles/server;
in
{
  imports = [
    inputs.clan-core.flakeModules.default
  ];

  clan = {
    inherit self;

    specialArgs = {
      inherit outputs;
      inherit inputs self;
    };

    meta.name = "grimoire";
    meta.domain = "spell";

    secrets.age.plugins = [
      "age-plugin-yubikey"
    ];

    inventory = {
      machines = {
        zoltraak.tags = [
          "headless"
          "server"
        ];

        catastravia = {
          deploy.targetHost = "root@46.224.129.105";
          tags = [
            "headless"
            "server"
          ];
        };
      };

      instances = {
        user-root = {
          module.name = "users";
          roles.default.tags.all = { };
          roles.default.settings = {
            user = "root";
            prompt = false;
            openssh.authorizedKeys.keyFiles = [ ./users/ssh.pub ];
          };
        };

        user-tydooo = {
          module.name = "users";
          roles.default.tags.all = { };
          roles.default.settings = {
            user = "tydooo";
            share = true;
            openssh.authorizedKeys.keyFiles = [ ./users/ssh.pub ];
          };
          roles.default.extraModules = [ ./users/tydooo/user.nix ];
        };

        sshd-basic = {
          module.name = "sshd";
          roles.server.tags.all = { };
          roles.client.tags.all = { };
        };

        base = {
          module.name = "importer";
          roles.default.tags = [ "all" ];
          roles.default.extraModules = [
            inputs.home-manager.nixosModules.home-manager

            common

            ./modules
          ];
        };

        server = {
          module.name = "importer";
          roles.default.tags = [ "server" ];
          roles.default.extraModules = [ server ];
        };

        emergency-access = {
          module.name = "emergency-access";
          roles.default.tags.nixos = { };
        };

        clan-cache = {
          module.name = "trusted-nix-caches";
          roles.default.tags.all = { };
        };

        internet = {
          module.name = "internet";
          roles.default.tags.server = { };
          roles.default.machines = {
            zoltraak.settings.host = "10.10.50.50";
            catastravia.settings.host = "46.224.129.105";
            nephtear.settings.host = "10.10.10.158";
          };
        };

        yggdrasil = {
          module.name = "yggdrasil";
          roles.default.tags.all = { };
        };

        wifi = {
          module.name = "wifi";
          roles.default.machines.nephtear = {
            settings.networks.home = { };
          };
        };
      };
    };
  };
}
