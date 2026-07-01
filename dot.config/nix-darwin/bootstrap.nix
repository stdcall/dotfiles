{ ... }:
# Минимальный nix-darwin профиль для первой активации на свежей macOS.
# Включает встроенный nix.linux-builder, у которого VM-образ есть в
# cache.nixos.org как substitute → не требует уже работающего aarch64-linux
# билдера. После активации этого профиля можно switch'нуться на основной
# конфиг (с nix-rosetta-builder), и тот соберётся через временный
# linux-builder. См. darwin-nix-bootstrap.sh.
{
  nixpkgs.hostPlatform = "aarch64-darwin";

  nix.settings.trusted-users = [ "@admin" ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.linux-builder.enable = true;

  system.stateVersion = 6;
}
