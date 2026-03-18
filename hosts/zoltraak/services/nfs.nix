{
  services.nfs-exports = {
    enable = true;
    clients = ["10.10.10.100"];

    shares = {
      music.source = "/mnt/disks/tank/media/music";
      sauce.source = "/mnt/user/sauce";
    };
  };
}
