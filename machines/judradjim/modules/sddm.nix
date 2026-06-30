{
  services.displayManager = {
    defaultSession = "niri";
    sddm = {
      enable = true;
      enableHidpi = true;
      wayland.enable = true;
    };
  };
}
