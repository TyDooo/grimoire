{
  imports = [
    ./keymap.nix
    ./monitors.nix
    ./rules.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mod" = "SUPER";

      exec-once = [
        "caelestia-shell"
      ];

      binds = {
        allow_workspace_cycles = false;
        focus_preferred_method = 1;

        workspace_center_on = 1;
      };

      ecosystem.no_update_news = true;

      dwindle = {
        pseudotile = true;
        preserve_split = true;
        use_active_for_splits = true;
      };

      input = {
        kb_layout = "us";

        follow_mouse = 1;
        float_switch_override_focus = 1;
        mouse_refocus = true;
        repeat_rate = 50;
        repeat_delay = 300;

        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          clickfinger_behavior = true;
        };

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      };

      general = {
        gaps_in = 4;
        gaps_out = 8;

        border_size = 2;

        layout = "dwindle";
        resize_on_border = true;
      };

      decoration = {
        rounding = 5;
        rounding_power = 2;

        # TODO: inherit opacity from stylix
        active_opacity = 0.95;
        inactive_opacity = 0.8;
        fullscreen_opacity = 1;

        shadow.enabled = false;

        blur = {
          enabled = true;
          size = 6;
          passes = 2;
          ignore_opacity = true;
          xray = false;
          popups = true;
        };
      };

      animations = {
        enabled = true;

        # Yes, these are the default animations, I'm lazy

        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];

        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
      };

      misc = {
        disable_splash_rendering = true;
        disable_hyprland_logo = true;
        animate_manual_resizes = true;
        animate_mouse_windowdragging = true;
        disable_autoreload = false;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        focus_on_activate = true;
        allow_session_lock_restore = true;
        new_window_takes_over_fullscreen = 1;
        enable_swallow = true;
      };
    };
  };
}
