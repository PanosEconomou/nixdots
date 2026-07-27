{ pkgs, config, configDir, ... }:
let
  repo = "${configDir}/modules/browsers/luakit/config";
  link = name: config.lib.file.mkOutOfStoreSymlink "${repo}/${name}";

  # Add a custom minimal GTK theme to get rid of some awful stuff there.
  luakit-themed = pkgs.symlinkJoin {
    name = "luakit-themed";
    paths = [ pkgs.luakit ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/luakit \
      --set-default GTK_THEME luakit-minimal
      '';
  };
in
{
  home.packages = [ luakit-themed ];

  # Symlink the configfiles
  xdg.configFile."luakit/theme.lua".source = link "theme.lua";
  xdg.configFile."luakit/userconf.lua".source = link "userconf.lua";
  xdg.configFile."luakit/modules".source = link "modules";
  xdg.dataFile."themes/luakit-minimal/gtk-3.0/gtk.css".source = link "gtk.css";

}
