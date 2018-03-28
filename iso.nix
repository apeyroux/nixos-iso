{config, pkgs, ...}:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  nixpkgs.config.allowUnfree = true;

  security = {
    sudo.wheelNeedsPassword = false;
  };

  networking.hostName = "nixos.iso.xn--wxa.computer";
  # networking.networkmanager.enable = true;
  
  programs.adb.enable = true;
  programs.bash.enableCompletion = true;
  programs.mosh.enable = true;
  programs.tmux.enable = true;
  programs.tmux.shortcut = "a";
  programs.tmux.terminal = "screen-256color";
  programs.tmux.clock24 = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  networking.firewall.enable = true;

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
    sudo
    trayer
    powerline-fonts
    feh
    xorg.xbacklight
  ];


  services.xserver.enable = true;
  services.xserver.autorun = true;
  services.xserver.layout = "fr";
  services.xserver.xkbOptions = "eurosign:e";
  services.xserver.libinput.enable = true;

  services.xserver.displayManager.slim.enable = true;

  services.xserver.resolutions = [
        { x = 2048; y = 1152; }
        { x = 1920; y = 1080; }
        { x = 1600; y = 900; }
	{ x = 1368; y = 768; }
	{ x = 1920; y = 1080; }
	{ x = 2560; y = 1440; }
	{ x = 2880; y = 1620; }
  ];

  # xmonad
  services.xserver.windowManager = {
    # i3.enable = true;
    xmonad.enable = true;
    xmonad.enableContribAndExtras = true;
    default = "xmonad";
  };

  services.xserver.desktopManager = {
    xfce.enable = true;
    xterm.enable = false;
    xfce.thunarPlugins = with pkgs.xfce; [ thunar-archive-plugin ];
    default = "none";
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
    virtualbox.host.enable = true;
  };

  nixpkgs.config.virtualbox = {
    enableExtensionPack = true;
    # pulseSupport = true;
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
