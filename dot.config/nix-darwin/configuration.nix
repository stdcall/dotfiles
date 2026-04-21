{ pkgs, lib, ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Users in admin group can offload builds to linux-builder.
  nix.settings.trusted-users = [ "@admin" ];

  # QEMU NixOS VM that Nix uses transparently as a remote Linux builder.
  # Supports both x86_64-linux (for cloud images) and aarch64-linux. Rosetta 2
  # accelerates x86_64 userspace — installed and verified.
  nix.linux-builder = {
    enable = true;
    ephemeral = true;
    maxJobs = 4;
    systems = [ "x86_64-linux" "aarch64-linux" ];
    config = {
      virtualisation = {
        cores = 6;
        darwin-builder = {
          diskSize = 40960;   # 40 GB (sparse)
          memorySize = 6144;  # 6 GB
        };
        # Expose Rosetta 2 to the Linux kernel → x86_64 userspace binaries
        # are executed via Rosetta instead of qemu-user emulation. На порядок
        # быстрее для наших YC-образов (x86_64-linux).
        rosetta.enable = true;
      };
    };
  };

  # On-demand режим: service установлен, но не запускается автоматически.
  # nix-darwin сам выставляет KeepAlive=true и RunAtLoad=true для builder'а —
  # нам нужно явно перебить через mkForce, иначе конфликт definition values.
  # Старт:  sudo launchctl kickstart system/org.nixos.linux-builder
  # Стоп:   sudo launchctl kill SIGTERM system/org.nixos.linux-builder
  launchd.daemons.linux-builder.serviceConfig = {
    RunAtLoad = lib.mkForce false;
    KeepAlive = lib.mkForce false;
  };

  # Enable flakes and the new CLI — required by our vpn project's flake.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = 5;
}
