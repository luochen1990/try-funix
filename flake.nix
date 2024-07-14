{
  description = "A Python development environment with pip";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        python3 = pkgs.python3.withPackages (p: with p; [
          # Add your required Python packages here
          requests
          numpy
          # Add more packages as needed
        ]);
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            python3
            pkgs.python3Packages.pip
            pkgs.python3Packages.virtualenv
            # Add other tools you need for development
            pkgs.git
          ];

          shellHook = ''
            echo "Welcome to your Python development environment with pip!"
          '';
        };
      });
}
