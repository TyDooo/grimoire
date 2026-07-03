{ inputs, ... }:
{
  perSystem =
    {
      inputs',
      config,
      pkgs,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        packages = [
          config.treefmt.build.wrapper

          inputs'.clan-core.packages.clan-cli
        ]
        ++ (with pkgs; [
          nixfmt
          nixos-anywhere

          just
          just-lsp

          git # Required to use flakes
          jujutsu

          # Secrets related stuff
          sops
          ssh-to-age
          gnupg
          age
          git-crypt
        ]);
      };
    };
}
