{ hosts, blueprints, nixos, home, ... }: {

  nixos = with nixos; [
    hw.nvidia-opt
    hw.hibernation-opt
    hw.stay-awake-opt
  ];

  home = [
  ];

}  
