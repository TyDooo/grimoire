{config, ...}: let
  dataDir = "/var/lib/trek";
in {
  systemd.tmpfiles.rules = [
    "d ${dataDir} 0755 root root - -"
    "d ${dataDir}/data 0755 root root - -"
    "d ${dataDir}/uploads 0755 root root - -"
    "d ${dataDir}/uploads/files 0755 root root - -"
    "d ${dataDir}/uploads/covers 0755 root root - -"
    "d ${dataDir}/uploads/avatars 0755 root root - -"
    "d ${dataDir}/uploads/photos 0755 root root - -"
  ];

  virtualisation.oci-containers.containers.trek = {
    image = "mauriceboe/trek:3";
    autoStart = true;
    extraOptions = ["--tmpfs=/tmp:noexec,nosuid,size=64m"];
    environment = {
      NODE_ENV = "production";
      TZ = "Europe/Amsterdam";
      LOG_LEVEL = "info";
      FORCE_HTTPS = "true";
      TRUST_PROXY = "1";
    };
    volumes = [
      "${dataDir}/data:/app/data"
      "${dataDir}/uploads:/app/uploads"
    ];
    ports = [
      "3020:3000"
    ];
    environmentFiles = [config.sops.secrets."trek/env".path];
  };

  sops.secrets."trek/env" = {};

  environment.persistence = {
    "/persist".directories = [
      {
        directory = dataDir;
        user = "root";
        group = "root";
        mode = "0755";
      }
    ];
  };
}
