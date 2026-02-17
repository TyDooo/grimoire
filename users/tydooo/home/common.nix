{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./programs

    inputs.stylix.homeModules.stylix
    inputs.caelestia-shell.homeManagerModules.default
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      # TODO: Check if still needed.
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "tydooo";
    homeDirectory = "/home/tydooo";
  };

  programs.home-manager.enable = true;
  news.display = "silent";

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  stylix = let
    themePath = theme: "${pkgs.base16-schemes}/share/themes/${theme}.yaml";
  in {
    enable = true;
    autoEnable = true;
    polarity = "dark";
    base16Scheme = themePath "rose-pine";

    opacity = {
      terminal = 0.9;
      popups = 0.8;
    };

    cursor = {
      package = pkgs.volantes-cursors;
      name = "volantes_cursors";
      size = 24;
    };

    fonts = {
      # serif = config.stylix.fonts.monospace;
      # sansSerif = config.stylix.fonts.monospace;
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = lib.mkDefault "24.11";
}
