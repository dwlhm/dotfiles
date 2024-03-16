{pkgs, lib, ...}: 
{
    home.username = "dwlhm";
    home.homeDirectory = "/home/dwlhm";
    home.stateVersion = "24.05"; # To figure this out you can comment out the line and see what version it expected.

    home.packages = [
		 pkgs.nerdfonts
     pkgs.zoxide
	   pkgs.lsd
	   pkgs.starship
		 pkgs.ripgrep
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

    programs.neovim = {
    	enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      plugins = with pkgs.vimPlugins; [
	  		catppuccin-nvim
	  		lualine-nvim
				nvim-tree-lua
				nvim-web-devicons
				mason-nvim
				mason-lspconfig-nvim
				nvim-lspconfig
				luasnip
				cmp-nvim-lsp
				cmp-buffer
				cmp-path
				cmp-nvim-lsp-signature-help
				plenary-nvim
				telescope-nvim
				telescope-ui-select-nvim
				nvterm
				dashboard-nvim
			];
	extraLuaConfig = lib.fileContents ./configs/nvim/init.lua;
    };

}
