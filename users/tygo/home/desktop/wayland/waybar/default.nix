{
  imports = [
    ./left.nix
    ./right.nix
    ./style.nix
  ];

  programs.waybar = {
    enable = true;
    settings = {
      main = {
        layer = "top";
        position = "right";
        margin = "8";
        output = "DP-1";
        reload_style_on_change = true;
      };
    };
  };
}
