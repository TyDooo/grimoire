let
  tank = "/mnt/disks/tank";
in
{
  services.nfs-exports = {
    enable = true;
    clients = [ "10.10.10.100" ];

    shares = {
      music.source = "${tank}/media/music";
      sauce.source = "${tank}/sauce";
    };
  };
}
