{pkgs, lib, ...}: 
let
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
    # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
    # ref = "nixos-23.05";
  });
in
{
    imports = [
        # For home-manager
        nixvim.homeManagerModules.nixvim
    ];
 
    home.username = "dwlhm";
    home.homeDirectory = "/home/dwlhm";
    home.stateVersion = "24.05"; # To figure this out you can comment out the line and see what version it expected.

    home.packages = [
        pkgs.nerdfonts
        pkgs.zoxide
	pkgs.lsd
	pkgs.starship
    ];

    programs.home-manager.enable = true;

    programs.fish = {
        enable = true;
	shellInit = ''
	    ${pkgs.zoxide}/bin/zoxide init fish | source
	    ${pkgs.starship}/bin/starship init fish | source
	'';
	shellAliases = {
	    ls = "lsd";
	};
    };

    programs.git = {
        enable = true;
	userName = "dwlhm";
	userEmail = "dwiilhamm026@gmail.com";
    };

    programs.nixvim = {
    enable = true;
    colorschemes.catppuccin = {
        enable = true;
        flavour = "mocha";
    };
    plugins.lualine = {
      enable = true;
    };
};

}
