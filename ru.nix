{ config, lib, pkgs, ... }:
{
  rune.project.name = "memcached";
  rune.lang.ruby.enable = true;
  aspect.packages.include = with pkgs; [
    python37Packages.sphinx
  ];
}
