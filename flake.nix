{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    flake-parts.url = "github:hercules-ci/flake-parts";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, treefmt-nix, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ treefmt-nix.flakeModule ];

      systems = [ "x86_64-linux" ];

      perSystem =
        { lib, system, ... }:
        let
          allowlistedLicenses = with lib.licenses; [
            bsl11 # Terraformを使うので許可します。個人的にもAGPLがフリーでbsl11がフリーじゃないのはあまり納得感がない。
          ];
          nixpkgsConfig = {
            inherit allowlistedLicenses;
          };
          pkgs = import inputs.nixpkgs {
            inherit system;
            config = nixpkgsConfig;
          };

          mackerelMcpServer = pkgs.callPackage ./pkgs/mackerel-mcp-server.nix { };
          mkr = pkgs.callPackage ./pkgs/mkr.nix { };
        in
        {
          packages = {
            inherit mackerelMcpServer;
          };
          treefmt.config = {
            projectRootFile = "flake.nix";
            programs = {
              actionlint.enable = true;
              deadnix.enable = true;
              hclfmt.enable = true;
              nixfmt.enable = true;
              prettier.enable = true;
              shellcheck.enable = true;
              shfmt.enable = true;
              terraform.enable = true;
              typos.enable = true;
              zizmor.enable = true;

              statix = {
                enable = true;
                disabled-lints = [ "eta_reduction" ];
              };
            };
            settings.formatter = {
              editorconfig-checker = {
                command = pkgs.lib.getExe (
                  pkgs.writeShellApplication {
                    name = "editorconfig-checker";
                    runtimeInputs = [ pkgs.editorconfig-checker ];
                    text = ''
                      editorconfig-checker -config .editorconfig-checker.json "$@"
                    '';
                  }
                );
                includes = [ "*" ];
                excludes = [ ".git/*" ];
              };
            };
          };
          apps = {
            terraform-validate = {
              type = "app";
              meta.description = "Terraform validate because network is required";
              program = pkgs.lib.getExe (
                pkgs.writeShellApplication {
                  name = "terraform-validate";
                  runtimeInputs = [ pkgs.terraform ];
                  text = ''
                    #!/usr/bin/env bash
                    set -euo pipefail
                    cd "$(git rev-parse --show-toplevel)"
                    terraform init -backend=false -lockfile=readonly
                    terraform validate
                  '';
                }
              );
            };
          };
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              cf-terraforming
              mkr
              sops
              terraform
              terraform-docs
              terraform-ls
              tflint
            ];
          };
        };
    };

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
