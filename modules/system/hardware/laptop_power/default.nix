# Some power management tools for laptoping and making sure 
# my battery doesn't get fried again hopefully
# Here is an interesting article: https://nixos.wiki/wiki/Laptop?__cf_chl_f_tk=M6TC_8hJKZ8CTsm9RTawMpz2ce1VTsQI1ywgzb3bmHg-1783015712-1.0.1.1-mN40_tEwmku_6VXMCkiiOIfYwCt89__rJzo0KC4UxrY
{ pkgs, ... }:
let
  # Script to tell the battery to charge up as much as possible
  batteryFull = pkgs.writeShellScriptBin "battery-full" ''
    exec ${pkgs.tlp}/bin/tlp fullcharge BAT0 
  '';

  # Conservative and takes care of the battery. Keeps it comfy between 50% and 60%
  batteryCare = pkgs.writeShellScriptBin "battery-care" ''
    exec ${pkgs.tlp}/bin/tlp setcharge 50 60 BAT0 
  '';
in
{
  # Proactively prevent overheating on intel CPUs
  services.thermald.enable = true;

  # Power and performance management tool
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC      = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT     = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC    = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT   = "power";

      CPU_MIN_PERF_ON_AC              = 0;
      CPU_MAX_PERF_ON_AC              = 100;
      CPU_MIN_PERF_ON_BAT             = 0;
      CPU_MAX_PERF_ON_BAT             = 60;

      START_CHARGE_THRESH_BAT0        = 50;
      STOP_CHARGE_THRESH_BAT0         = 60;
    };
  };

  # Load the custom scripts
  environment.systemPackages = [ batteryFull batteryCare ];

  # Let them execute without sudo
  security.sudo.extraRules = [{
    groups = [ "wheel" ];
    commands =[ 
      { command = "/run/current-system/sw/bin/battery-full"; options = [ "NOPASSWD" ]; }
      { command = "/run/current-system/sw/bin/battery-care"; options = [ "NOPASSWD" ]; }
    ];
  }];
}
