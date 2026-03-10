{
  virtualisation.oci-containers.containers.frigate = {
    image = "ghcr.io/blakeblackshear/frigate:stable";
    autoStart = true;
    ports = [
      "5000:5000"
      "8554:8554"
      "8555:8555/tcp"
      "8555:8555/udp"
      "8971:8971"
    ];
    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "/var/lib/frigate:/config"
      "/mnt/disks/frigate:/media/frigate"
    ];
    environment = {
      TZ = "Europe/Amsterdam";
      LIBVA_DRIVER_NAME = "iHD";
      XDG_RUNTIME_DIR = "/tmp";
    };
    devices = [
      "/dev/dri/renderD128:/dev/dri/renderD128"
      "/dev/bus/usb:/dev/bus/usb"
    ];
    capabilities = {
      CAP_PERFMON = true;
    };
    extraOptions = [
      "--privileged"
      "--shm-size=256m" # increase shared memory for ffmpeg
      "--mount=type=tmpfs,target=/tmp/cache,tmpfs-size=1000000000"
    ];
  };

  environment.persistence = {
    "/persist".directories = [
      {
        directory = "/var/lib/frigate";
        user = "root";
        group = "root";
        mode = "0750";
      }
    ];
  };
}
