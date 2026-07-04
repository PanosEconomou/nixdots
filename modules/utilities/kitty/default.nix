{ config, configDir, ... }:
let
  repo = "${configDir}/modules/utilities/kitty/config";
  link = name: config.lib.file.mkOutOfStoreSymlink "${repo}/${name}";
in
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
    extraConfig = ''
      include current-theme.conf
      include properties.conf
      '';
  };

# Symlink current theme and theme folder
  xdg.configFile."kitty/current-theme.conf".source =  link "current-theme.conf";
  xdg.configFile."kitty/properties.conf".source =     link "properties.conf";
  xdg.configFile."kitty/themes".source =              link "themes";
}

