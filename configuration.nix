# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "TUFA16"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable Xbox Series X/S bluetooth connectivity
  hardware.xpadneo.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tom = {
    isNormalUser = true;
    description = "tom";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "tom";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  #Automatic upgrades
  system.autoUpgrade.enable = true; 
  system.autoUpgrade.allowReboot = true;

  #Automatic garbage collection and store deduplication
  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 30d";
    };
  };

  #Setup global editor variable for neovim
  environment.variables = { EDITOR = "nvim"; };

  #Steam needs this for some reason
  programs.steam.enable = true; 


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #developer tools
    vscode-with-extensions
    arduino
    gcc_multi
    python312
    cmake
    wget
    neovim
    ansible
    git
    picotool
    pico-sdk

  #Misc Apps
    freecad
    libreoffice
    google-chrome

  #Terminal Utilities
    tmux
    btop
    neofetch

  #System Utilities
    rpi-imager
    nfs-utils
    usbutils

  #Work Apps
    zoom-us

  #Media
    vlc
    headsetcontrol
    gimp

  #Games
    steam

  #UI Tools
    gnome.gnome-tweaks

  ];

  #NFS auto-mounts (fstab-like)
  fileSystems."/home/tom/Media/Media" = {
    device = "192.168.1.50:/mnt/user/Media";
    fsType = "nfs4";
  };
  fileSystems."/home/tom/Media/Pics_Docs" = {
    device = "192.168.1.50:/mnt/user/Pics_Docs";
    fsType = "nfs4";
  };
  fileSystems."/home/tom/Media/System" = {
    device = "192.168.1.50:/mnt/user/system";
    fsType = "nfs4";
  };
  fileSystems."/home/tom/Media/Backup" = {
    device = "192.168.1.10:/mnt/Backup/Backup";
    fsType = "nfs4";
  };
  fileSystems."/home/tom/Steam" = {
    device = "/dev/disk/by-uuid/4d77b5c8-f2da-4623-b22e-00f82169faf7";
    fsType = "ext4";
  };

  # Fonts go here
  fonts.packages = with pkgs; [
	nerdfonts
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [27040];
  #networking.firewall.allowedUDPPorts = [... ];
  #networking.firewall.allowedTCPPortRanges = [
  #  { from = 4000; to = 4007; }
  #  { from = 8000; to = 8010; }
  #];
  networking.firewall.allowedUDPPortRanges = [
    { from = 27031; to = 27036; }
  ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
