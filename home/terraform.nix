{ pkgs, ... }: {

  home.packages = with pkgs; [
    terraform
    terragrunt
  ];

  home.shellAliases = {
    "tf" = "terraform";
    "tg" = "terragrunt";
  };

}
