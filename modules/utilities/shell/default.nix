{ config, pkgs, ... }:
let
  repo = "${config.home.homeDirectory}/.nixos/modules/utilities/shell/config";
  link = name: config.lib.file.mkOutOfStoreSymlink "${repo}/${name}";
in
{
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
}

