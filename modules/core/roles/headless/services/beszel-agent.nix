{ config, pkgs, ... }:
let
  # TODO: move to lib
  mkEnvGenerator = envs: rec {
    files.envfile = { };
    runtimeInputs = [ pkgs.coreutils ];
    prompts = pkgs.lib.genAttrs envs (_name: {
      persist = false;
    });

    # Invalidate on env change
    validation.script = script;

    script = ''
      mkdir -p $out
      cat <<EOT >> $out/envfile
      ${builtins.concatStringsSep "\n" (map (e: "${e}='$(cat $prompts/${e})'") envs)}
      EOT
    '';
  };
in
{
  services.beszel.agent = {
    enable = true;
    smartmon.enable = true;
    environmentFile = config.clan.core.vars.generators."beszel-agent".files."envfile".path;
    environment = {
      HUB_URL = "http://100.99.158.193:8090";
    };
  };

  clan.core.vars.generators."beszel-agent" = mkEnvGenerator [
    "KEY"
    "TOKEN"
  ];
}
