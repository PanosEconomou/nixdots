{ config, configDir, lib, ... }:
let
  cfg = config.pantry.home.utilities.kitty;
  repo = "${configDir}/modules/home/utilities/kitty/config";
  link = name: config.lib.file.mkOutOfStoreSymlink "${repo}/${name}";
in
{
  options.pantry.home.utilities.kitty = {
    enable = lib.mkEnableOption "enable kitty";
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;

      # Some basic settings
      settings = {
        enable_audio_bell = false;
        disable_ligatures = "never";
        confirm_os_window_close = 0;
        allow_remote_control = "socket-only";
        listen_on = "unix:/tmp/kitty";
        enabled_layouts="splits";
        window_border_width = "0";
        window_margin_width = "0";
        active_border_color = "none";
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
    };
}
