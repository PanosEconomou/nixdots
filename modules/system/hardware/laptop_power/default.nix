# Some power management tools for laptoping and making sure 
# my battery doesn't get fried again hopefully
# Here is an interesting article: https://nixos.wiki/wiki/Laptop?__cf_chl_f_tk=M6TC_8hJKZ8CTsm9RTawMpz2ce1VTsQI1ywgzb3bmHg-1783015712-1.0.1.1-mN40_tEwmku_6VXMCkiiOIfYwCt89__rJzo0KC4UxrY
{ pkgs, ... }:
let
  # Script to tell the battery to charge up as much as possible
  batteryFull = pkgs.writeShellScriptBin "battery-full" ''
    exec ${pkgs.tlp}/bin/tlp fullcharge BAT0 
  '';

  # Keeps the battery comfy between 50% and 60%
  batteryCare = pkgs.writeShellScriptBin "battery-care" ''
    exec ${pkgs.tlp}/bin/tlp setcharge 50 60 BAT0 
  '';

  # Toggles between the two modes
  batteryToggle = pkgs.writeShellScriptBin "battery-toggle" ''
    end_threshold=$(cat /sys/class/power_supply/BAT0/charge_control_end_threshold)
    if [ "$end_threshold" -ge 90 ]; then 
      echo "Switching to care mode"
      exec ${pkgs.tlp}/bin/tlp setcharge 50 60 BAT0 
    else 
      echo "Switching to full mode"
      exec ${pkgs.tlp}/bin/tlp fullcharge BAT0 
    fi 
  '';
in
{
  # Proactively prevent overheating on intel CPUs
  services.thermald.enable = true;

  # Power and performance management tool
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC      = "powersave";
      CPU_SCALING_GOVERNOR_ON_BAT     = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC    = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT   = "balance_performance";

      CPU_HWP_DYN_BOOST_ON_AC         = 1;
      CPU_HWP_DYN_BOOST_ON_BAT        = 1;

      PLATFORM_PROFILE_ON_AC          = "balanced";
      PLATFORM_PROFILE_ON_BAT         = "balanced";

      CPU_MIN_PERF_ON_AC              = 0;
      CPU_MAX_PERF_ON_AC              = 90;
      CPU_MIN_PERF_ON_BAT             = 0;
      CPU_MAX_PERF_ON_BAT             = 90;

      START_CHARGE_THRESH_BAT0        = 50;
      STOP_CHARGE_THRESH_BAT0         = 60;
    };
  };

  # Load the custom scripts
  environment.systemPackages = [ batteryFull batteryCare batteryToggle ];

  # Let them execute without sudo
  security.sudo.extraRules = [{
    groups = [ "wheel" ];
    commands =[ 
      { command = "/run/current-system/sw/bin/battery-full";   options = [ "NOPASSWD" ]; }
      { command = "/run/current-system/sw/bin/battery-care";   options = [ "NOPASSWD" ]; }
      { command = "/run/current-system/sw/bin/battery-toggle"; options = [ "NOPASSWD" ]; }
    ];
  }];
}
