{
  wayland.windowManager.hyprland.settings = {
    windowrule = [
      "float,class:^(Choose Files)$"
      "float,class:^(Choose Directory)$"

      "workspace special:comms, class:(telegram-desktop)"

      "noanim,class:^(rofi)$"

      "float,initialTitle:(Picture-in-Picture)"
      "float,title:Choose*"
    ];

    layerrule = [
      "ignorezero, zen-beta"
      "blur, zen-beta"
      "blurpopups, zen-beta"
    ];
  };
}
