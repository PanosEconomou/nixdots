{ pkgs, ... }:
{
  boot.plymouth = {
    enable = true;
    themePackages = [
      (pkgs.adi1090x-plymouth-themes.override {
        selected_themes = [ "splash" ];
      })
    ];
    theme = "splash";
  };

  boot.kernelParams = [ "quiet" "splash" ];
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
}
