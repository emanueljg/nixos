rec {
  baseSecretName = "mailserver-ejg-password";
  serverSecret = "hashed-${baseSecretName}";
  clientSecret = "unhashed-${baseSecretName}";
  sopsCfg = {
    sopsFile = ../../../secrets/${baseSecretName}.yaml;
    mode = "0440";
  };
}
