{ other, ... }: {
  environment.systemPackages =
    builtins.attrValues other.vidya;
}
