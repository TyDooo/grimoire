{
  lib,
  inputs,
  withSystem,
  ...
}:
let
  inherit (self) outputs;
  inherit (inputs) self nixpkgs;
  inherit (lib.lists) singleton concatLists;

  vars = import ../vars/private.nix;

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

  mkNixosSystem =
    { system, ... }@args:
    withSystem system (
      {
        inputs',
        self',
        ...
      }:
      lib.nixosSystem {
        specialArgs = {
          inherit outputs;
          inherit inputs self;
          inherit inputs' self';
          inherit vars;
        };
        modules = concatLists [
          (singleton {
            networking.hostName = args.hostname;
            nixpkgs = {
              hostPlatform = lib.mkDefault args.system;
              flake.source = nixpkgs.outPath;
            };

          })

          (args.modules or [ ])
        ];
      }
    )

  ;

  mkModulesFor =
    hostname:
    {
      roles ? [ ],
      extra ? [ ],
    }:

    [
      common

      ../users/tydooo/user.nix
      ../users/root/user.nix

      ../modules

      ./${hostname}/host.nix
      ./${hostname}/disko.nix
      ./${hostname}/hardware.nix
    ]
    ++ roles
    ++ extra
    ++ shared;
in
{
  flake.nixosConfigurations = {
    # judradjim = mkHost {
    #   hostname = "judradjim";
    #   system = "x86_64-linux";
    # };

    zoltraak = mkNixosSystem {
      hostname = "zoltraak";
      system = "x86_64-linux";
      modules = mkModulesFor "zoltraak" {
        roles = [
          headless
          server
        ];
        extra = [ inputs.vpn-confinement.nixosModules.default ];
      };
    };

    mistilziela = mkNixosSystem {
      hostname = "mistilziela";
      system = "aarch64-linux";
      modules = mkModulesFor "mistilziela" {
        roles = [
          headless
          server
        ];
      };
    };
  };
}
