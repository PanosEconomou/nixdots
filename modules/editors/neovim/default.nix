{ config, configDir, pkgs, ... }:
let
  repo = "${configDir}/modules/editots/neovim";
  link = name: config.lib.file.mkOutOfStoreSymlink "${repo}/${name}";
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
  };

  # Symlink the config files.
  xdg.configFile."nvim/init.lua".source = link "init.lua";
  xdg.configFile."nvim/lua".source      = link "lua";

  # Enable treesiter for colors and whatnot
  home.packages = [ pkgs.tree-sitter ];
}

