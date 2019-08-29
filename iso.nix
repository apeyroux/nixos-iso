{config, pkgs, ...}:

let

  version = "iso-19.03";
  
in {
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  boot.supportedFilesystems = [ "zfs" ];

  nixpkgs.config.allowUnfree = true;

  security = {
    sudo.wheelNeedsPassword = false;
  };

  networking.hostName = "nixos.iso.xn--wxa.computer";
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
    emacs
    firefox
    sudo
    unzip
    google-chrome
    htop
    vim
    networkmanager
  ];


  services.xserver = {
    enable = true;
    autorun = true;
    layout = "fr";
    xkbOptions = "eurosign:e";
    libinput.enable = true;
    displayManager.slim.enable = true;

    desktopManager = {
      xfce.enable = true;
      xterm.enable = false;
      xfce.thunarPlugins = with pkgs.xfce; [ thunar-archive-plugin ];
      default = "none";
      };
  };

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
                                        emacs
					                              git
    			                              gnupg
    			                              unzip
    			                              htop
    			                              termite
    			                              vim
																				firefox
    			               ];
}
