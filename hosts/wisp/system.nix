{ ... }:
{
  imports = [ ../../modules/system ];
  pantry.system = {
    window_manager = {
      hyprland.enable = true;
    };

    display_manager = {
      sddm.enable = true;
    };

    hardware = {
      bluetooth.enable = true;
      keyd.enable = true;
      laptop_power.enable = true;
      intel_graphics.enable = true;
    };

    utilities = {
      fonts.enable = true;
      upower.enable = true;
      wayland_tools.enable = true;
      qt.enable = true;
      plymouth.enable = true;
    };

  };
}
