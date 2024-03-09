# dwlhm dotfile's
Konfigurasi terminal menggunakan nix home-manager.
Tercerahkan oleh: https://www.chrisportela.com/posts/home-manager-flake/

## Cara penggunaan 
1. Install nix 
  `curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install`
2. Clone repository ini
3. Build konfigurasi home-manager
   `nix run . -- build --flake .
4. Apply konfigurasi home-manager
   `nix run . -- switch -b backup --flake .
5. Restart shell
   `exec $SHELL -l`

## Catatan
- Baru digunakan pada WSL Ubuntu-20.14
- Mengganti default shell ke fish bawaan home-manager bisa mendatangkan error, karenanya install dan jadikan fish sebagai shell bawaan terlebih dahulu kemudian baru apply konfigurasi home-manager
- Untuk konfigurasi manual fish bisa ikuti [**tutorial ini**](https://linuxtldr.com/installing-fish/).
