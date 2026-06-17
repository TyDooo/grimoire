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

  shared = [
    inputs.home-manager.nixosModules.home-manager
    inputs.disko.nixosModules.default
    inputs.stylix.nixosModules.stylix
  ];
in
{
  flake = {
    # nixosConfigurations = {
    #   # judradjim = mkHost {
    #   #   hostname = "judradjim";
    #   #   system = "x86_64-linux";
    #   # };

    #   zoltraak = mkNixosSystem {
    #     hostname = "zoltraak";
    #     system = "x86_64-linux";
    #     modules = mkModulesFor "zoltraak" {
    #       roles = [
    #         headless
    #         server
    #       ];
    #       extra = [ inputs.vpn-confinement.nixosModules.default ];
    #     };
    #   };
    # };

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

        machines = {
          zoltraak = {
            nixpkgs.hostPlatform = "x86_64-linux";
            imports = [
              common

              ../users/tydooo/user.nix
              ../users/root/user.nix

              ../modules

              ./zoltraak/host.nix
              ./zoltraak/disko.nix
              ./zoltraak/hardware.nix

              headless
              server

              inputs.vpn-confinement.nixosModules.default
            ]
            ++ shared;
          };
        };
      }
    );
  };
}
