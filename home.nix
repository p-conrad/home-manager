{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      hello
    ];

    username = "peter";
    homeDirectory = "/var/home/peter";

    stateVersion = "24.05";
  };
}
