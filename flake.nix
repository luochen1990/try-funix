{
  description = "A Python development environment with pip & poetry";

  inputs = {
    nixpkgs.url = "nixpkgs";
  };

  outputs = { self, nixpkgs }:
  let
    supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    eachSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f rec {
      inherit system;
      pkgs = import nixpkgs { inherit system; };
      hpkgs = pkgs.haskell.packages.ghc928;
      python3 = pkgs.python3.withPackages (p: with p; [
        # Add your required Python packages here
        requests
        numpy
        # Add more packages as needed
      ]);
      pyver = pkgs.python3.version;
    });
  in
  {
    devShells = eachSystem ({pkgs, python3, pyver, ...}: rec {
      default = poetry;

      poetry = pkgs.mkShell {
        buildInputs = [
          python3
          pkgs.poetry
          # Add other tools you need for development
          pkgs.git
        ];

        shellHook = ''
          echo "Welcome to your Python development environment with poetry!"

          #export PROMPT_COMMAND='PS1="\[\033[01;32m\]venv-py${pyver}\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ ";unset PROMPT_COMMAND'
          export PROMPT_COMMAND='PS1="";unset PROMPT_COMMAND'

          export PATH=$(poetry env info --path)/bin:$PATH
        '';
      };

      pip = pkgs.mkShell {
        buildInputs = [
          python3
          pkgs.python3Packages.pip
          pkgs.python3Packages.virtualenv
          pkgs.python3Packages.setuptools
          pkgs.python3Packages.wheel
          pkgs.python3Packages.typing-extensions
          # Add other tools you need for development
          pkgs.git
        ];

        shellHook = ''
          echo "Welcome to your Python development environment with pip!"

          export PROMPT_COMMAND='PS1="\[\033[01;32m\]venv-py${pyver}\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ ";unset PROMPT_COMMAND'

          python3 -m venv --system-site-packages ${builtins.toString ./.venv-py${pyver}}
          source ${builtins.toString ./.venv-py${pyver}/bin/activate}

          export PIP_EXTRA_INDEX_URL=https://pypi.tuna.tsinghua.edu.cn/simple

          if [ -f setup.py ] || [ -f setup.cfg ]; then
            echo "Detected setuptools project. Initializing pip environment..."
            pip install -e .
          elif [ -f requirements.txt ]; then
            echo "Detected pip project. Initializing pip environment..."
            pip install -r requirements.txt
          fi
        '';
      };
    });

    apps = eachSystem ({system, pkgs, ...}: {
      default = {
        type = "app";
        program = "${pkgs.writeShellScript "funix-app" ''
          source ${self.devShells.${system}.default.shellHook}
          funix ./src
        ''}";
      };
    });

  };
}
