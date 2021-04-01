{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/ad47284f8b01f587e24a4f14e0f93126d8ebecda.tar.gz") {}
}:

pkgs.mkShell {
  buildInputs = [ pkgs.idris2 pkgs.idrisPackages.prelude ];
}
