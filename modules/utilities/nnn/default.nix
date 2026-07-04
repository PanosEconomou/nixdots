{ config, configDir, ... }:
let
  repo = "${configDir}/modules/utilities/nnn/config";
  link = name: config.lib.file.mkOutOfStoreSymlink "${repo}/${name}";
in
{
  programs.nnn = {
    enable = true;
  };
  
  # Symlink config file 
  xdg.configFile."nnn/nnn.sh".source = link "nnn.sh";
}
