{ config, lib, ... }:
let
  cfg = config.pantry.home.utilities.git;
in
{
  options.pantry.home.utilities.git = {
    enable = lib.mkEnableOption "enable git";
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      settings = {
        user.name = "Panos Oikonomou";
        user.email = "panos.economou.v@gmail.com";
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };
  };
}
