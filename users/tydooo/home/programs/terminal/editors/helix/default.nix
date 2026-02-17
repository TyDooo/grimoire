{pkgs, ...}: {
  imports = [./languages.nix];

  programs.helix = {
    enable = true;
    extraPackages = with pkgs; [
      nil
      alejandra
      gopls
      golangci-lint-langserver
      delve
      golangci-lint
    ];
    settings = {
      editor = {
        indent-guides.render = true;
        lsp.display-inlay-hints = true;
        cursorline = true;
        color-modes = true;
      };
    };
  };
}
