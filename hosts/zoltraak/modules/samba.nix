{
  # The SMB shares are only used by the backup server. For other systems use NFS instead.

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "smbnix";
        "netbios name" = "smbnix";
        "security" = "user";
        "hosts allow" = "10.10.1.242";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
      "immich" = {
        "path" = "/mnt/disks/tank/immich";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "valid users" = "immich";
        "force user" = "immich";
        "force group" = "immich";
      };
      "backup" = {
        "path" = "/mnt/disks/tank/backup";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "valid users" = "pve, homeassistant";
        "force user" = "root";
        "force group" = "backup";
      };
      "media" = {
        "path" = "/mnt/user/media";
        "browseable" = "yes";
        "read only" = "yes";
        "guest ok" = "no";
        "valid users" = "tydooo";
        "force user" = "root";
        "force group" = "media";
      };
    };
  };

  environment.persistence = {
    "/persist".directories = [
      {
        directory = "/var/lib/samba";
        user = "root";
        group = "root";
        mode = "0755";
      }
    ];
  };
}
