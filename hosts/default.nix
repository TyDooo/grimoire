{
  lib,
  self,
  inputs,
  withSystem,
  ...
}: let
  inherit (self) outputs;
  inherit (lib.lists) singleton concatLists;

  vars = import ../vars/private.nix;

  mkHost = {
    hostname,
    system,
    ...
  } @ args:
    withSystem system (
      {
        inputs',
        self',
        ...
      }:
        inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs outputs inputs' self' vars;};
          modules = concatLists [
            (singleton {
              networking.hostName = hostname;
              nixpkgs.hostPlatform = lib.mkDefault system;
            })

            [
              ./common/global
              ../users/tydooo/user.nix
              ../users/root/user.nix

              ../modules

              ./${hostname}/host.nix
              ./${hostname}/disko.nix
              ./${hostname}/hardware.nix

              inputs.home-manager.nixosModules.home-manager
              inputs.disko.nixosModules.default
              inputs.stylix.nixosModules.stylix
            ]

            # Optinally allow per host modules
            (args.modules or [])
          ];
        }
    );
in {
  flake.nixosConfigurations = {
    # judradjim = mkHost {
    #   hostname = "judradjim";
    #   system = "x86_64-linux";
    #   modules = [
    #     inputs.chaotic.nixosModules.default
    #   ];
    # };

    zoltraak = mkHost {
      hostname = "zoltraak";
      system = "x86_64-linux";
      modules = [
        inputs.vpn-confinement.nixosModules.default
      ];
    };
  };
}
