{pkgs, ...}: {
    home.username = "dwlhm";
    home.homeDirectory = "/home/dwlhm";
    home.stateVersion = "24.05"; # To figure this out you can comment out the line and see what version it expected.

    home.packages = [
        pkgs.nerdfonts
        pkgs.zoxide
        pkgs.neovim
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

}
