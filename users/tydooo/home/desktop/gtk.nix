{ pkgs, ... }: {
  gtk = {
    enable = true;
    gtk4.theme = null;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
  };
}
