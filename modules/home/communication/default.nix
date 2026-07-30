{
  imports =
    let
      dir = ./.;
      names = builtins.attrNames (builtins.readDir dir);
      isModule = name:
        builtins.pathExists (dir + "/${name}/default.nix");
    in
    map (name: dir + "/${name}") (builtins.filter isModule names);
}
