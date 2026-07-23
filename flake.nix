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

      # 2. Docker-image build
      packages.${system}.docker = pkgs.dockerTools.streamLayeredImage {
        name = "my-app";
        tag = "latest";
        contents = [
          
        ];
        config = {
         Entrypoint = [ "/bin/app" ];
         # Cmd = [ "--default-flags" ];
        };
      };
    };
}
