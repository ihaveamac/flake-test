{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }: let
    forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
  in{

    packages = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      gay = pkgs.stdenvNoCC.mkDerivation {
        name = "gay";

        unpackPhase = "true";

        buildPhase = ''
          echo "#!${pkgs.bash}/bin/sh" >> gay
          echo "echo you are gay" >> gay
        '';

        installPhase = ''
          chmod +x gay
          mkdir -p $out/bin/
          cp gay $out/bin/
        '';
      };
      default = self.packages.${system}.gay;
    });

  };
}
