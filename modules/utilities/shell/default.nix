{ config, pkgs, ... }:
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
  home.file.".bash_aliases".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixos/modules/utilities/shell/bash_aliases";

  # Load starship
  programs.starship.enable = true;
}

