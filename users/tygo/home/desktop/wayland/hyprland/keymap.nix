{
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland = {
    settings = {
      # Swap the Caps Lock and CTRL keys
      input.kb_options = "caps:swapescape";

      bind = let
        workspaces = [
          "0"
          "1"
          "2"
          "3"
          "4"
          "5"
          "6"
          "7"
          "8"
          "9"
        ];

        # Map keys (arrows and hjkl) to hyprland directions (l, r, u, d)
        directions = rec {
          left = "l";
          right = "r";
          up = "u";
          down = "d";
          h = left;
          l = right;
          k = up;
          j = down;
        };

        terminal = lib.getExe pkgs.kitty;
        menu = lib.getExe pkgs.rofi;
      in
        [
          "$mod,Q,killactive"
          "$mod,S,togglesplit"
          "$mod,F,togglefloating,"

          "$mod,R,exec,${menu} -show drun"
          "$mod,T,exec,${terminal}"

          "$modSHIFT,o,exec,hyprctl --batch 'setprop active opaque toggle; setprop inactive opaque toggle'"
          "$modCTRL,c,centerwindow,"
        ]
        ++
        # Change workspace
        (map (n: "$mod,${n},workspace,${n}") workspaces)
        ++
        # Move window to workspace
        (map (n: "$modSHIFT,${n},movetoworkspacesilent,${n}") workspaces)
        ++
        # Move focus
        (lib.mapAttrsToList (key: direction: "$mod,${key},movefocus,${direction}") directions)
        ++
        # Swap windows
        (lib.mapAttrsToList (key: direction: "$modSHIFT,${key},swapwindow,${direction}") directions)
        ++
        # Move windows
        (lib.mapAttrsToList (
            key: direction: "$modCONTROL,${key},movewindow,${direction}"
          )
          directions)
        ++
        # Move monitor focus
        (lib.mapAttrsToList (key: direction: "$modALT,${key},focusmonitor,${direction}") directions)
        ++
        # Move workspace to other monitor
        (lib.mapAttrsToList (
            key: direction: "$modALTSHIFT,${key},movecurrentworkspacetomonitor,${direction}"
          )
          directions);

      bindm = [
        "$mod,mouse:272,movewindow"
        "$mod,mouse:273,resizewindow 2"
      ];

      # Will repeat when h[e]ld, also works when [l]ocked
      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

      # Also works when [l]ocked
      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
    };
  };
}
