{ pkgs, lib, ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";

  nix.settings.trusted-users = [ "@admin" ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Linux builder via nix-rosetta-builder (from cpick/nix-rosetta-builder).
  # Uses Apple Virtualization framework + Lima, which natively mounts
  # Rosetta 2 into the guest VM at /run/rosetta → x86_64 userspace runs
  # at ~native speed instead of qemu-user emulation.
  #
  # Control:
  #   sudo launchctl kickstart system/rosetta-builderd   — start
  #   sudo launchctl kill SIGTERM system/rosetta-builderd — stop
  # With onDemand=true, the VM starts automatically on first build SSH
  # and powers itself off after onDemandLingerMinutes of inactivity.
  nix-rosetta-builder = {
    onDemand = true;
    onDemandLingerMinutes = 60;  # default 180 is long; 1h suits our rhythm
    cores = 6;
    memory = "6GiB";
    diskSize = "40GiB";           # default 100GiB → overkill for our builds
  };

  system.stateVersion = 6;
}
