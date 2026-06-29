{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
  };

  # Symlink the config files.
  xdg.configFile."nvim/init.lua".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixos/modules/editors/neovim/init.lua";
  xdg.configFile."nvim/lua".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixos/modules/editors/neovim/lua";

  # Enable treesiter for colors and whatnot
  home.packages = [ pkgs.tree-sitter ];
}

