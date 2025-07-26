{
  programs.waybar.settings.main = {
    modules-left = [
      "hyprland/workspaces"
    ];

    "hyprland/workspaces" = {
      format = "{icon}";
      on-click = "activate";
      all-outputs = true;
      format-icons = {
        "1" = "一";
        "2" = "二";
        "3" = "三";
        "4" = "四";
        "5" = "五";
        "6" = "六";
        "7" = "七";
        "8" = "八";
        "9" = "九";
        "10" = "十";
      };
    };

    "group/info" = {
      orientation = "inherit";
      drawer = {
        transition-duration = 500;
        transition-left-to-right = false;
      };
      modules = [
        "custom/dmark"
        "group/gcpu"
        "memory"
        "disk"
      ];
    };

    "custom/dmark" = {
      format = "";
      tooltip = false;
    };

    "group/gcpu" = {
      orientation = "inherit";
      modules = ["cpu"];
    };

    cpu = {
      format = " 󰻠\n{usage}%";
      on-click = "kitty btop";
    };

    memory = {
      on-click = "kitty btop";
      format = "  \n{}%";
    };

    disk = {
      on-click = "kitty btop";
      interval = 600;
      format = " 󰋊\n{percentage_used}%";
      path = "/";
    };
  };
}
