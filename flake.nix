{
  description = "Synapse dev env";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            python311 python311Packages.pip python311Packages.uvicorn
            python311Packages.virtualenv python311Packages.typer
            nodejs_20 terraform
            git jq mermaid-cli
          ];
        };
      });
}
