{config, ...}: let
  alphaValue = config.stylix.opacity.popups;
in {
  stylix.targets.waybar.addCss = false;

  programs.waybar.style =
    # css
    ''
      * {
          min-width: 8px;
          min-height: 0px;
        }

        window#waybar {
          transition-property: background-color;
          transition-duration: 0.5s;
          border-radius: 8px;
          border: 2px solid @base06;
          background: alpha(@base00, ${builtins.toString alphaValue});
          color: lighter(@base06);
        }

        menu,
        tooltip {
          border-radius: 8px;
          padding: 2px;
          border: 1px solid lighter(@base06);
          background: alpha(@base00, 0.6);

          color: lighter(@base06);
        }

        menu label,
        tooltip label {
          font-size: 14px;
          color: lighter(@base06);
        }

        #submap,
        #tray>.needs-attention {
          animation-name: blink-active;
          animation-duration: 1s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }

        .modules-right {
          margin: 0px 6px 6px 6px;
          border-radius: 4px;
          background: alpha(@base00, 0.4);
          color: lighter(@base06);
          padding: 2px 2px 4px 2px;
        }

        .modules-left {
          transition-property: background-color;
          transition-duration: 0.5s;
          margin: 6px 6px 6px 6px;
          border-radius: 4px;
          background: alpha(@base00, 0.4);
          color: lighter(@base06);
        }

        #gcpu,
        #custom-github,
        #custom-notifications,
        #memory,
        #disk,
        #together,
        #submap,
        #custom-weather,
        #custom-recorder,
        #connection,
        #cnoti,
        #power,
        #custom-updates,
        #tray,
        #privacy {
          margin: 3px 0px;
          border-radius: 4px;
          background: alpha(darker(@base06), 0.3);
        }

        #audio {
          margin-top: 3px;
        }

        #brightness,
        #audio {
          border-radius: 4px;
          background: alpha(darker(@base06), 0.3);
        }

        #custom-notifications {
          padding-right: 4px;
        }

        #custom-hotspot,
        #custom-github,
        #custom-notifications {
          font-size: 14px;
        }

        #custom-hotspot {
          padding-right: 2px;
        }

        #custom-vpn,
        #custom-hotspot {
          background: alpha(darker(@base06), 0.3);
        }

        #privacy-item {
          padding: 6px 0px 6px 6px;
        }

        #gcpu {
          padding: 8px 0px 8px 0px;
        }

        #custom-cpu-icon {
          font-size: 25px;
        }

        #custom-cputemp,
        #disk,
        #memory,
        #cpu {
          font-size: 14px;
          font-weight: bold;
        }

        #custom-github {
          padding-top: 2px;
          padding-right: 4px;
        }

        #custom-dmark {
          color: alpha(@base0F, 0.3);
        }

        #submap {
          margin-bottom: 0px;
        }

        #workspaces {
          margin: 0px 2px;
          padding: 4px 0px 0px 0px;
          border-radius: 8px;
        }

        #workspaces button {
          transition-property: background-color;
          transition-duration: 0.5s;
          color: @base0F;
          background: transparent;
          border-radius: 4px;
          color: alpha(@base0F, 0.3);
        }

        #workspaces button.urgent {
          font-weight: bold;
          color: @base0F;
        }

        #workspaces button.active {
          padding: 4px 2px;
          background: alpha(@base06, 0.4);
          color: lighter(@base06);
          border-radius: 4px;
        }

        #network.wifi {
          padding-right: 4px;
        }

        #submap {
          min-width: 0px;
          margin: 4px 6px 4px 6px;
        }

        #custom-weather,
        #tray {
          padding: 4px 0px 4px 0px;
        }

        #bluetooth {
          padding-top: 2px;
        }

        #battery {
          border-radius: 8px;
          padding: 4px 0px;
          margin: 4px 2px 4px 2px;
        }

        #battery.discharging.warning {
          animation-name: blink-yellow;
          animation-duration: 1s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }

        #battery.discharging.critical {
          animation-name: blink-red;
          animation-duration: 1s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }

        #clock {
          font-weight: bold;
          padding: 4px 2px 2px 2px;
        }

        #pulseaudio.mic {
          border-radius: 4px;
          color: @base00;
          background: alpha(darker(@base0F), 0.6);
        }

        #backlight-slider slider,
        #pulseaudio-slider slider {
          background-color: transparent;
          box-shadow: none;
        }

        #backlight-slider trough,
        #pulseaudio-slider trough {
          margin-top: 4px;
          min-width: 6px;
          min-height: 60px;
          border-radius: 8px;
          background-color: alpha(@base00, 0.6);
        }

        #backlight-slider highlight,
        #pulseaudio-slider highlight {
          border-radius: 8px;
          background-color: lighter(@base06);
        }

        #bluetooth.discoverable,
        #bluetooth.discovering,
        #bluetooth.pairable {
          border-radius: 8px;
          animation-name: blink-active;
          animation-duration: 1s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }

        @keyframes blink-active {
          to {
            background-color: @base06;
            color: @base0F;
          }
        }

        @keyframes blink-red {
          to {
            background-color: #c64d4f;
            color: @base0F;
          }
        }

        @keyframes blink-yellow {
          to {
            background-color: #cf9022;
            color: @base0F;
          }
        }
    '';
}
