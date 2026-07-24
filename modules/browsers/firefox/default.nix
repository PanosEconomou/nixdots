{ config, configDir, ... }: 
let
  repo = "${configDir}/modules/browsers/firefox/config";
  link = name: config.lib.file.mkOutOfStoreSymlink "${repo}/${name}";
in
{
  programs.firefox = {
    enable = true;
  };
}
