{ pkgs, ... }:
let 
  username = "pano";
  greetconf = pkgs.writeText "greetd-hyprland.lua" ''
    hl.on("hyprland.start", function()
      hl.dispatch(hl.dsp.exec_cmd("${pkgs.greetd.regreet}/bin/regreet; hyprctl dispatch 'hl.dsp.exit()'"))
    end)
    hl.config({
      misc = {
        disable_hyprland_logo           = true,
        disable_splash_rendering        = true,
        disable_hyprland_guiutils_check = true,
      },
    })
    '';
in
{
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "dbus-run-session start-hyprland -- -c ${greetconf}";
      user    = username;
    };
    # settings.default_session.command = "${config.programs.hyprland.package}/bin/Hyprland --config ${greetconf}";
  };

  programs.regreet = {
    enable = true;
    settings = {
      path  = "/var/lib/wallpaper/current.png";
      fit   = "Cover";
    };
  };

  environment.systemPackages = [ pkgs.imagemagick];
  systemd.tmpfiles.rules = [
    "d /var/lib/sddm-wallpaper 0755 ${username} users -"
  ];
}
