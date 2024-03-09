{pkgs, lib, ...}: {

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

}
