{ pkgs, ... }: {

  my.home.packages = with pkgs; [
    terraform
    terragrunt
  ];

  my.home.shellAliases = {
    "tf" = "terraform";
    "tg" = "terragrunt";
  };

}
