{
  inputs',
  inputs,
  ...
}: let
  spicePkgs = inputs'.spicetify-nix.legacyPackages;
in {
  imports = [
    inputs.spicetify-nix.homeManagerModules.spicetify
  ];

  programs.spicetify = {
    enable = true;
    enabledCustomApps = with spicePkgs.apps; [
      reddit
      newReleases
    ];
    enabledExtensions = with spicePkgs.extensions; [
      hidePodcasts
      shuffle
    ];
  };
}
