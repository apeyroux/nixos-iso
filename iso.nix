{config, pkgs, ...}:

let

  version = "iso-20.11";
  
in {
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.enableUnstable = true;

  nixpkgs.config.allowUnfree = true;

  security = {
    sudo.wheelNeedsPassword = false;
  };

  networking.hostName = "nixos.iso.px.io";
  networking.firewall.enable = true;
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;

  programs.adb.enable = true;
  programs.bash.enableCompletion = true;
  programs.mosh.enable = true;
  programs.tmux.enable = true;
  programs.tmux.shortcut = "a";
  programs.tmux.terminal = "screen-256color";
  programs.tmux.clock24 = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "fr";
    defaultLocale = "fr_FR.UTF-8";
  };

  time.timeZone = "Europe/Paris";

  environment.systemPackages = with pkgs; [
    git
    gnupg
    sudo
    unzip
    htop
    vim
    networkmanager
  ];

  users.extraUsers.alex = {
    isNormalUser = true;
    password = "alex";
    extraGroups = ["wheel"
                   "adbusers"
                   "disks"
                   "networkmanager"];
  };

  isoImage.makeUsbBootable = true;
  isoImage.makeEfiBootable = true;
  isoImage.includeSystemBuildDependencies = true; # offline install
  isoImage.storeContents = with pkgs; [ tmux
                                        mosh
					                              git
    			                              gnupg
    			                              unzip
    			                              htop
    			                              vim
    			               ];
}
