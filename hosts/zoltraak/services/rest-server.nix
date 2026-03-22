{config, ...}: {
  services.restic.server = {
    enable = true;
    listenAddress = "8745";
    privateRepos = true;
    dataDir = "/mnt/disks/tank/backup/restic";
    htpasswd-file = config.sops.secrets."restic/server/passwd".path;
  };

  users.users.restic.extraGroups = ["backup"];

  systemd.tmpfiles.rules = [
    "d /mnt/disks/tank/backup/restic 2775 restic backup - -"
  ];

  sops.secrets."restic/server/passwd" = {
    owner = "restic";
    group = "restic";
    mode = "0600";
  };

  networking.firewall.allowedTCPPorts = [8745];
}
