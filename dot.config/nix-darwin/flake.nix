{
  description = "Personal macOS (nix-darwin) configuration — nkhodyunya-osx";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Apple-Virt-framework-based Linux builder with Rosetta 2 mount + real
    # on-demand launchd management (VM auto-stops after inactivity). Replaces
    # nix-darwin's `nix.linux-builder` which lacks Rosetta support.
    nix-rosetta-builder = {
      url = "github:cpick/nix-rosetta-builder";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nix-darwin, nix-rosetta-builder, ... }:
    let
      mkSystem = nix-darwin.lib.darwinSystem {
        modules = [
          nix-rosetta-builder.darwinModules.default
          ./configuration.nix
        ];
      };
      # Bootstrap-профиль для первой активации на свежей macOS — без
      # nix-rosetta-builder, чтобы разорвать chicken-and-egg. См. bootstrap.nix.
      mkBootstrap = nix-darwin.lib.darwinSystem {
        modules = [ ./bootstrap.nix ];
      };
    in {
      darwinConfigurations."bootstrap"      = mkBootstrap;
      darwinConfigurations."nkhodyunya-osx" = mkSystem;
      darwinConfigurations."nagisa-osx"     = mkSystem;
    };
}
