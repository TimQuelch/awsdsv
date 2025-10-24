{
  description = "awsdsv";

  inputs.nixpkgs.url = "github:nixos/nixpkgs";

  outputs =
    { self, nixpkgs, ... }:
    let
      systems = [
        "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forEachSystem = nixpkgs.lib.genAttrs systems;
      pname = "awsdsv";
    in
    {
      overlays.default = final: prev: {
        ${pname} = final.callPackage ./package.nix {};
      };

      packages = forEachSystem (system: {
        ${pname} = nixpkgs.legacyPackages.${system}.callPackage ./package.nix {};
        default = self.packages.${system}.${pname};
      });
    };
}
