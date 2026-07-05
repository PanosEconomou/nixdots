{ pkgs, config, configDir, ... }:
let
  repo = "${configDir}/modules/browsers/luakit/config";
  link = name: config.lib.file.mkOutOfStoreSymlink "${repo}/${name}";
in
{
  home.packages = [ pkgs.luakit ];

  # Symlink the configfiles
  xdg.configFile."luakit/theme.lua".source = link "theme.lua";
  # xdg.configFile."luakit/rc.lua".source = link "rc.lua";
}
