# PanOS

Teheeee! Some nixos config files.

## Quick Reminders

Make sure to clone this in `~/.nixos` in order to work properly. I know this makes no sense so I will figure out how to deal with this soon. 

To rebuild do
```shell
$ nixos-rebuild switch --flake ~/.nixos#<HOSTNAME>
```

## Cleaning up

There is a lot of accumulated garbage in nixos with all the rebuilds being stored. If you are sure that you are in a stable build you can cleanup by
```shell
$ nix-env --list-generations --profile /nix/var/nix/profiles/system
$ nix-collect-garbage -d
nix-collect-garbage -d
$ nixos-rebuild boot
```
