{
  systemd = {
    enableEmergencyMode = false;

    settings.Manager = {
      WatchdogDevice = "/dev/watchdog";
      RuntimeWatchdogSec = "20s";
      RebootWatchdogSec = "30s";
    };
  };
}
