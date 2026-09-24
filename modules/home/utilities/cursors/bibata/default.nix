{ config, lib, pkgs, ... }:
let
  cfg = config.pantry.home.utilities.cursors.bibata;
in
{
  options.pantry.home.utilities.cursors.bibata = {
    enable = lib.mkEnableOption "enable bibata cursor";
  };

  config = lib.mkIf cfg.enable {
    home.pointerCursor = {
      enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 20;
      gtk.enable = true;
      x11.enable = true;
      hyprcursor.enable = true;
    };

    gtk = {
      enable = true;
      # theme = {
      #   package = pkgs.flat-remix-gtk;
      #   name = "Flat-Remix-GTK-Grey-Darkest";
      # };
      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };
      font = {
        name = "Sans";
        size = 11;
      };
    };
  };
}
