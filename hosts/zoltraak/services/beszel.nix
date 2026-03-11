{config, ...}: {
  services.beszel.agent = {
    enable = true;
    smartmon.enable = true;
    environmentFile = config.sops.secrets."beszel-env".path;
  };

  sops.secrets."beszel-env" = {
    owner = "beszel-agent";
    group = "beszel-agent";
  };
}
