{ pkgs, ... }:
let
  # A UCM profile for the EVO4 has been added in v1.2.16, but is not yet
  # available in nixpkgs unstable. Override the config by setting the
  # ALSA_CONFIG_UCM2 environment variable.
  #
  # FIXME: remove when v1.2.16 or newer is avaliable in nixpkgs
  alsa-ucm-conf' = pkgs.alsa-ucm-conf.overrideAttrs {
    src = pkgs.fetchurl {
      url = "mirror://alsa/lib/alsa-ucm-conf-1.2.16.1.tar.bz2";
      hash = "sha256-zz0cB+CJqDxOziwg8F3WqKq3/NEIdow4gROGiAV1SSs=";
    };
    version = "1.2.16.1";
    patches = [ ];
  };

  extraEnv = {
    ALSA_CONFIG_UCM2 = "${alsa-ucm-conf'}/share/alsa/ucm2";
  };
in
{
  environment.sessionVariables = extraEnv;

  systemd.services = {
    pipewire.environment = extraEnv;
    wireplumber.environment = extraEnv;
  };

  services.pipewire.wireplumber.extraConfig = {
    "9-audient-evo4" = {
      "monitor.alsa.rules" = [
        {
          # Unused: disable
          matches = [
            { "node.description" = "~EVO4 Loopback.*"; }
            { "node.description" = "EVO4 Mic 2 / Line 2"; }
          ];
          actions.update-props = {
            "node.disabled" = true;
          };
        }
      ];
    };
  };
}
