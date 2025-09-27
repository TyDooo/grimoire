{
  imports = [
    ./hyprland
    ./rofi
  ];

  programs.caelestia = {
    enable = true;
    systemd.enable = false;
    settings = {
      bar.status = {
        showBattery = false;
      };
    };
  };
}
