{ pkgs, ... }:
{
  home.pointerCursor = {
    package = pkgs.google-cursor;
    name = "GoogleDot-White";
    size = 20;
    gtk.enable = true;
    x11.enable = true;
    hyprcursor.enable = true;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
    font = {
      name = "Sans";
      size = 11;
    };
  };
}
