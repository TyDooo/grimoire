{config, ...}: {
  # Until https://github.com/NixOS/nixpkgs/pull/450093 is merged
  virtualisation.oci-containers.containers.seerr = {
    image = "ghcr.io/seerr-team/seerr:latest";
    autoStart = true;
    ports = ["5055:5055"];
    volumes = [
      "/var/lib/seerr:/app/config"
    ];
    extraOptions = [
      "--init"
    ];
    environment = {
      LOG_LEVEL = "debug";
      TZ = config.time.timeZone;
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/frigate 0750 1000 1000 - -"
  ];

  environment.persistence = {
    "/persist".directories = [
      {
        directory = "/var/lib/seerr";
        user = "root";
        group = "root";
        mode = "0750";
      }
    ];
  };
}
