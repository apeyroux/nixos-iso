{config, lib, pkgs, ...}:

{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  boot.supportedFilesystems = [ "zfs" ];

  nixpkgs.config.allowUnfree = true;

  security = {
    sudo.wheelNeedsPassword = false;
  };

  networking.hostName = "nixos-srv.iso.xn--wxa.computer";
  networking.firewall.enable = true;
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;

  environment.noXlibs = lib.mkDefault true;
  lib.i18n.supportedLocales = [ (config.i18n.defaultLocale + "/UTF-8") ];
  services.nixosManual.enable = lib.mkDefault false;

  programs.bash.enableCompletion = true;
  programs.mosh.enable = true;
  programs.tmux.enable = true;
  programs.tmux.shortcut = "b";
  programs.tmux.terminal = "screen-256color";
  programs.tmux.clock24 = true;

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "fr";
    defaultLocale = "fr_FR.UTF-8";
  };

  time.timeZone = "Europe/Paris";

  environment.systemPackages = with pkgs; [
    emacs25-nox
    git
    gnupg
    htop
    networkmanager
    unzip
  ];

  users.extraUsers.alex = {
    isNormalUser = true;
    password = "alex";
    extraGroups = ["wheel"
                   "adbusers"
                   "disks"
                   "networkmanager"
                   "vboxusers"
                   "docker"];
  };

  isoImage.makeUsbBootable = true;
  isoImage.makeEfiBootable = true;
  isoImage.includeSystemBuildDependencies = false; # offline install
}
