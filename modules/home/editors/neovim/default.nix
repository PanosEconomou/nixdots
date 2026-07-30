{ config, configDir, lib, pkgs, ... }:
let
  cfg = config.pantry.home.editors.neovim;
  repo = "${configDir}/modules/home/editors/neovim";
  link = name: config.lib.file.mkOutOfStoreSymlink "${repo}/${name}";
in
{
  options.pantry.home.editors.neovim = {
    enable = lib.mkEnableOption "enable neovim";
  };

  config = lib.mkIf cfg.enable {
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
  };
}
