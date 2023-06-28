let 
  inherit (import ./_common.nix) domain;
in {

  "router" = {
    ip = "10.100.0.1";
    isNixOS = false;
    endpoint = domain;
    publicKey = "Bp3EtoiNq+JCJxzWF8e8OK26a4vk9JylkLMeZZwwkgc=";
  };

  "crown" = {
    ip = "10.100.0.2";
    endpoint = "crown.${domain}";
    publicKey = "Bp3EtoiNq+JCJxzWF8e8OK26a4vk9JylkLMeZZwwkgc=";
  };

  "void" = {
    ip = "10.100.0.3";
    endpoint = "void.${domain}";
    publicKey = "aqAjZuTpYIXrlT70y7MRouIICxPEaNZh8B9fsaYrqmc=";
  };

  "seneca" = {
    ip = "10.100.0.4";
    endpoint = "seneca.${domain}";
    publicKey = "7xZFjr/q01WlGztjaa0Q5wtj0yPtzx4xespyYkXezB0=";
  };

  "epictetus" = {
    ip = "10.100.0.5";
    isNixOS = false;
    endpoint = "84.216.154.84";
    publicKey = "eVsJNs3dUIN4Lpc4Fk/NgUNh8tZc5WM5GwbtG/f+kmc=";
  };

  "fenix" = {
    ip = "10.100.0.6";
    endpoint = "fenix.${domain}";
    publicKey = "1O9lktS5Q0yZZYgqf1pJgdYtedWUzLqbGvdEyVlXqUQ=";
  };
  
}
