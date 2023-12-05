# Project demonstrating how to build flutter project with devenv and nix

## Getting Started

This projects use the following softwares to build a flutter project
- [Nix & NixOS | Reproducible builds and deployments](https://nixos.org/)
- [direnv – unclutter your .profile | direnv](https://direnv.net/)
- [Fast, Declarative, Reproducible, and Composable Developer Environments - devenv](https://devenv.sh/)

In order to build the flutter project and run the app in an android emulator, you need to
install nix and direnv, and then run the following commands

```
direnv allow # Allow direnv to use devenv defined in flake.nix
create-avd # Create an Android Virtual Device (AVD)
devenv up emulator # Start the Android emulator
```

Now run `flutter run` in another terminal, you should see you app started in the Android terminal.

Special thanks to @hatch01, for pointing out how to make nix and flutter work together in [Documentation: Flutter Flake · Issue #267263 · NixOS/nixpkgs](https://github.com/NixOS/nixpkgs/issues/267263).
