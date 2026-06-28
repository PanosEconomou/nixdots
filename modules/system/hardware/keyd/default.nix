{ ... }:
{
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      extraConfig = builtins.readFile ./default.conf;
    };
  }; 
}

