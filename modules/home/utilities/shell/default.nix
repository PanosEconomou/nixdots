{ config, configDir, lib, pkgs, ... }:
let
  cfg = config.pantry.home.utilities.shell;
  repo = "${configDir}/modules/home/utilities/shell/config";
  link = name: config.lib.file.mkOutOfStoreSymlink "${repo}/${name}";
in
{
  options.pantry.home.utilities.shell = {
    enable = lib.mkEnableOption "enable shell utilities";
  };

  config = lib.mkIf cfg.enable {
    programs.bash = {
      enable = true;
      bashrcExtra = ''
        # If there are aliases load them
        if [ -f $HOME/.bash_aliases ]; then
            source $HOME/.bash_aliases
        fi 
      '';
    };

    # Copy the config symlinks
    home.file.".bash_aliases".source = link "bash_aliases";

    # Load starship
    programs.starship.enable = true;

    # Load it's configuration
    xdg.configFile."starship.toml".source = link "starship.toml";

    # Load the language server
    home.packages = with pkgs; [
      bash-language-server
    ];
  };
}
