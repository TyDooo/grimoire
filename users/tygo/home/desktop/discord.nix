{inputs, ...}: {
  imports = [
    inputs.nixcord.homeModules.nixcord
  ];

  programs.nixcord = {
    enable = true;
    config = {
      useQuickCss = true;
      frameless = true;
      plugins = {
        messageLogger = {
          enable = true;
          collapseDeleted = true;
        };
        showMeYourName.enable = true;
        fakeNitro.enable = true;
      };
    };
  };
}
