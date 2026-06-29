{ pkgs, ... }:
let
  # 0WD0's niri fork (wd/vertical-layout branch) - adds two-dimensional
  # layouting so niri works on vertical monitors.
  niriFork = pkgs.niri.overrideAttrs (_oldAttrs: rec {
    version = "unstable-fork-2026-06-19";

    src = pkgs.fetchFromGitHub {
      owner = "0WD0";
      repo = "niri";
      rev = "4a351116b95dc652e8ae428b5a1910132b69112f";
      hash = "sha256-ycLNYc4E5nDv69W62DtiNB5t+gGBTjVNAKWllPFPZzU=";
    };

    cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
      inherit src;
      name = "niri-unstable-fork-2026-06-19";
      hash = "sha256-jGORNwJ/F9UrajObXdGLbOTGEpCv919puUuWojbuVwo=";
    };

    # The fork's Cargo.toml version probably won't match `version` above,
    # so skip the version-string sanity check.
    doInstallCheck = false;
  });
in
{
  programs.niri.enable = true;
  programs.niri.package = niriFork;

  environment.systemPackages = with pkgs; [
    noctalia-shell
  ];
}
