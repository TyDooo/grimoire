{ config, ... }:
{
  services.restic.server = {
    enable = true;
    listenAddress = "8745";
    privateRepos = true;
    dataDir = "/mnt/disks/tank/backup/restic";
    htpasswd-file = config.clan.core.vars.generators."rest-server".files."htpasswd".path;
  };

  users.users.restic.extraGroups = [ "backup" ];

  systemd.tmpfiles.rules = [
    "d /mnt/disks/tank/backup/restic 2775 restic backup - -"
  ];

  clan.core.vars.generators."rest-server" = {
    prompts."htpasswd" = {
      persist = true;
      type = "multiline";
    };
    files."htpasswd" = {
      owner = "restic";
      group = "restic";
      mode = "0600";
    };
  };

  networking.firewall.allowedTCPPorts = [ 8745 ];
}
