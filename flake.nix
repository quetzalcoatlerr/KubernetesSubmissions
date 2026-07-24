{
  description = "k8s_mooc";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # 1. devshell (direnv: 'use flake')
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          go
          k3d
          kubectl
          kubernetes-helm
        ];

        shellHook = ''
          echo " Dev Environment Ready!"
        '';
      };

      # 2. Binary app + Docker-image build
      packages.${system} = rec {
        logOut = pkgs.buildGoModule {
          pname = "log_output";
          version = "0.1.0";
          src = ./log_output;
          vendorHash = null;
        };

        docker = pkgs.dockerTools.streamLayeredImage {
          name = "log_output";
          tag = "latest";
          contents = [
            logOut
            pkgs.cacert
          ];
          config = {
            Entrypoint = [ "${logOut}/bin/log_output" ];
          };
        };
      };
    };
}
