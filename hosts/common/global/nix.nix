{
  nix = {
    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = "nix-command flakes";
      warn-dirty = false;

      trusted-users = ["root" "@wheel"];
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };
  };

  nixpkgs.config.allowUnfree = true;
}
