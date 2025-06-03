{ ... }: {
  networking.nameservers = [
    "192.168.0.1"
    "10.100.0.1"
    "fdec:2d90:c92a::1"
  ];
}
