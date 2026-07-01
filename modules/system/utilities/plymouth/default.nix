{ pkgs, ... }:
{
  # Add the graphics card to boot early so that we can see it
  boot.initrd.systemd.enable = true;
  boot.initrd.kernelModules = [ "i915" ];

  # Use playmouth with a cool theme
  boot.plymouth = {
    enable = true;
    themePackages = [
      (pkgs.adi1090x-plymouth-themes.override {
        selected_themes = [ "splash" ];
      })
    ];
    theme = "splash";
  };

  # Get rid of the linux start text
  boot.kernelParams = [ "quiet" "splash" ];
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
}
