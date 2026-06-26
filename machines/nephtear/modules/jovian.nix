{ inputs, ... }: {
  imports = [
    inputs.jovian-nixos.nixosModules.jovian
  ];

  jovian.devices.steamdeck.enable = true;
  jovian.devices.steamdeck.autoUpdate = true;

  jovian.steam.enable = true;
  jovian.steam.autoStart = true;
  jovian.steam.user = "tydooo";
  jovian.steam.desktopSession = "gamescope-wayland";

  # jovian.decky-loader.enable = true;

  services.desktopManager.plasma6.enable = true;

  programs.steam = {
    enable = true;
    extest.enable = true;
    remotePlay.openFirewall = true;
  };

  # environment.persistence = {
  #   "/persist".directories = [
  #     {
  #       directory = config.jovian.decky-loader.stateDir;
  #       inherit (config.jovian.decky-loader) user;
  #       group = "decky";
  #       mode = "0775";
  #     }
  #   ];
  # };
}
