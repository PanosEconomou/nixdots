{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user.name = "Panos Oikonomou";
      user.email = "panos.economou.v@gmail.com";
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}

