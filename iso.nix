{config, pkgs, ...}:

let

  version = "1.0";
  
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
    (import /home/alex/src/emacs.nix/default.nix {})
    firefox
    sudo
    unzip
    google-chrome
    haskellPackages.xmobar
    htop
    termite
    vim
    networkmanager
    trayer
    powerline-fonts
    feh
    xorg.xbacklight
  ];


  services.xserver = {
    enable = true;
    autorun = true;
    layout = "fr";
    xkbOptions = "eurosign:e";
    libinput.enable = true;
    displayManager.slim.enable = true;

    # xmonad
    windowManager = {
      # i3.enable = true;
      xmonad.enable = true;
      xmonad.enableContribAndExtras = true;
      default = "xmonad";
    };

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
                   "networkmanager"
                   "vboxusers"
                   "docker"];
  };

  virtualisation = {
    docker.enable = true;
  };
  
  isoImage.makeUsbBootable = true;
  isoImage.makeEfiBootable = true;
  isoImage.includeSystemBuildDependencies = true; # offline install
  isoImage.storeContents = with pkgs; [ tmux
                                        mosh
					                              (import /home/alex/src/emacs.nix/default.nix {})
					                              git
    			                              gnupg
    			                              unzip
    			                              google-chrome
    			                              haskellPackages.xmobar
    			                              htop
    			                              termite
    			                              vim
    			                              powerline-fonts
    			                              feh
					                              firefox
    			                              xorg.xbacklight ];
}
