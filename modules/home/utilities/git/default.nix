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
      lfs.enable = true;
      settings = {
        user.name = "Panos Oikonomou";
        user.email = "panos.economou.v@gmail.com";
        init.defaultBranch = "main";
        pull.rebase = true;
        alias = {
          lg = "log --graph --abbrev-commit --decorate --all --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'";
        };
      };
    };
  };
}
