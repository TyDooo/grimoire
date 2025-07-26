{pkgs, ...}: {
  fonts = {
    fontconfig.enable = true;

    packages = with pkgs;
      [
        noto-fonts
        noto-fonts-extra
        noto-fonts-emoji
        noto-fonts-color-emoji

        noto-fonts-cjk-sans
        noto-fonts-cjk-serif

        ipafont
        kochi-substitute
        dejavu_fonts
      ]
      ++ (with pkgs.nerd-fonts; [
        jetbrains-mono
      ]);
  };
}
