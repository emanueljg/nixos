{ config, lib, ... }:

with lib; let
  cfg = config.customOpts.boot;
in {


  options = {
    method = m
