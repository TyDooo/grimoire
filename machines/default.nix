{
  inputs,
  withSystem,
  ...
}:
let
  inherit (self) outputs;
  inherit (inputs) self;

  modulePath = ../modules;

  coreModules = modulePath + /core;

  common = coreModules + /common;

  # ROLES
  headless = coreModules + /roles/headless;
  server = coreModules + /roles/server;
in
{
  flake = {
    clan = withSystem "x86_64-linux" (
      {
        inputs',
        self',
        ...
      }:
      {
        inherit self;

        specialArgs = {
          inherit outputs;
          inherit inputs self;
          inherit inputs' self';
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
          };

          instances = {
            user-root = {
              module.name = "users";
              roles.default.tags.all = { };
              roles.default.settings = {
                user = "root";
                prompt = false;
                openssh.authorizedKeys.keyFiles = [ ../users/ssh.pub ];
              };
            };

            user-tydooo = {
              module.name = "users";
              roles.default.tags.all = { };
              roles.default.settings = {
                user = "tydooo";
                share = true;
                openssh.authorizedKeys.keyFiles = [ ../users/ssh.pub ];
              };
              roles.default.extraModules = [ ../users/tydooo/user.nix ];
            };

            base = {
              module.name = "importer";
              roles.default.tags = [ "all" ];
              roles.default.extraModules = [
                inputs.home-manager.nixosModules.home-manager
                inputs.disko.nixosModules.default
                inputs.stylix.nixosModules.stylix

                common

                ../modules
              ];
            };

            headless = {
              module.name = "importer";
              roles.default.tags = [ "headless" ];
              roles.default.extraModules = [ headless ];
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
          };
        };
      }
    );
  };
}
