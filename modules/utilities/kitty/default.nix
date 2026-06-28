{ config, pkgs, ... }:
{
  programs.kitty = {
    enable = true;

    # Some basic settings
    settings = {
      enable_audio_bell = false;
      disable_ligatures = "never";
      confirm_os_window_close = 0;
    };
   
   # Theme management
   extraConfig = "include current-theme.conf";
  };

  # Symlink current theme and theme folder
  xdg.configFile."kitty/current-theme.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixos/modules/utilities/kitty/current-theme.conf";
  xdg.configFile."kitty/themes".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixos/modules/utilities/kitty/themes";
}

