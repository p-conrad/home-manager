{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      hello
    ];

    username = "peter";
    homeDirectory = "/home/peter";

    programs.home-manager.enable = true;

    #stateVersion = "24.05";
  };
}
