{ clanLib, ... }: {
  _class = "clan.service";
  manifest.name = "beszel";
  manifest.description = "beszel hub and agents";
  manifest.readme = builtins.readFile ./README.md;
  manifest.categories = [
    "Network"
    "System"
  ];
  manifest.exports.out = [ "endpoints" ];

  # Only one hub per clan
  manifest.constraints.roles.hub.minMachines = 1;
  manifest.constraints.roles.hub.maxMachines = 1;

  roles.hub = {
    description = "Sets up the Beszel hub";

    perInstance =
      {
        instanceName,
        mkExports,
        roles,
        meta,
        ...
      }:
      {
        exports = mkExports { endpoints.hosts = [ "beszel.${meta.domain}" ]; };

        nixosModule =
          {
            grimoire-utils,
            config,
            pkgs,
            lib,
            ...
          }:
          let
            generatorName = "beszel-hub-${instanceName}";
            gen = config.clan.core.vars.generators.${generatorName};
            dataDir = config.services.beszel.hub.dataDir;

            clientMachines = lib.attrNames (roles.agent.machines or { });

            beszelClientSystems = map (
              machine:
              let
                host = if machine == config.networking.hostName then "127.0.0.1" else "${machine}.${meta.domain}";
                port = 45876; # TODO: get from agent options
              in
              {
                name = machine;
                inherit host port;
                users = [ ("tygo" + "@" + "driessen." + "family") ];
              }
            ) (lib.sort builtins.lessThan clientMachines);

            beszelConfigYml = (pkgs.formats.yaml { }).generate "config.yml" {
              systems = beszelClientSystems;
            };
          in
          {
            clan.core.vars.generators.${generatorName} = {
              files."beszel.ssh.pub".secret = false;
              files."beszel.ssh" = {
                secret = true;
                owner = "beszel-hub";
                group = "beszel-hub";
              };

              runtimeInputs = [ pkgs.openssh ];

              script = ''
                ssh-keygen -t ed25519 -N "" -C "" -f "$out"/beszel.ssh
              '';
            };

            clan.core.vars.generators."${generatorName}-env" = grimoire-utils.mkEnvGenerator [
              "USER_EMAIL"
              "USER_PASSWORD"
            ];

            services.caddy = {
              enable = true;
              virtualHosts."beszel.${meta.domain}".extraConfig =
                "reverse_proxy 127.0.0.1:${toString config.services.beszel.hub.port}";
            };

            users.users.beszel-hub = {
              isSystemUser = true;
              group = "beszel-hub";
            };
            users.groups.beszel-hub = { };

            services.beszel.hub = {
              enable = true;
              environmentFile = config.clan.core.vars.generators."${generatorName}-env".files."envfile".path;
            };

            systemd.services.beszel-hub.serviceConfig = {
              DynamicUser = lib.mkForce false;
              User = "beszel-hub";
              Group = "beszel-hub";
            };

            systemd.services.beszel-hub.preStart = ''
              ln -sf ${gen.files."beszel.ssh".path} ${dataDir}/beszel_data/id_ed25519
              ln -sf ${gen.files."beszel.ssh.pub".path} ${dataDir}/beszel_data/id_ed25519.pub
              ln -sf ${beszelConfigYml} ${dataDir}/beszel_data/config.yml
            '';

            environment.persistence = {
              "/persist".directories = [
                {
                  directory = dataDir;
                  user = "beszel-hub";
                  group = "beszel-hub";
                }
              ];
            };
          };
      };
  };

  roles.agent = {
    description = "Sets up the Beszel agent";

    interface = { lib, ... }: {
      options = {
        port = lib.mkOption {
          type = lib.types.port;
          default = 45876;
          description = "Port the beszel agent listens on.";
        };
      };
    };

    perInstance = { instanceName, settings, ... }: {
      nixosModule =
        { config, ... }:
        let
          # hubMachines = roles.hub.machines or [ ];
          # hubMachine = lib.head hubMachines;

          pubKey = clanLib.getPublicValue {
            flake = config.clan.core.settings.directory;
            # machine = hubMachine;
            machine = "catastravia";
            generator = "beszel-hub-${instanceName}";
            file = "beszel.ssh.pub";
          };
        in
        {
          services.beszel.agent = {
            enable = true;
            environment = {
              KEY = pubKey;
              LISTEN = toString settings.port;
            };
          };

          environment.persistence = {
            "/persist".directories = [
              "/var/lib/beszel-agent"
            ];
          };
        };
    };
  };
}
