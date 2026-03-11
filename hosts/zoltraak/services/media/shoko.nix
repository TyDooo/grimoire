{lib, ...}: {
  services.shoko = {
    enable = true;
    openFirewall = true;
  };

  users = {
    groups.shoko = {};
    users.shoko = {
      group = "shoko";
      isSystemUser = true;
      extraGroups = ["media"];
    };
  };

  systemd.services.shoko.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = "shoko";
    Group = "shoko";
  };

  systemd.tmpfiles.rules = [
    "d ${media_dir}/import/anime 2775 shoko media - -"
  ];

  environment.persistence = {
    "/persist".directories = [
      {
        directory = "/var/lib/shoko";
        user = "shoko";
        group = "shoko";
        mode = "0750";
      }
    ];
  };
}
