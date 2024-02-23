{ tf-vault-backend, pkgs, config, ... }: {
  imports = [
    tf-vault-backend.nixosModules.default
  ];
  services.tf-vault-backend = {
    enable = true;
    vault = {
      address = "localhost:8200";
    };
    backend = { };
  };

  systemd.services.vault-testing-init = {
    wantedBy = [ "vault.service" ];
    after = [ "network-online.target" "vault.service" ];
    before = [ "tf-vault-backend.service" ];
    serviceConfig = {
      ExecStart = pkgs.writeShellApplication {
        name = "vault-testing-init";
        runtimeInputs = with pkgs; [
          jq
          config.services.tf-vault-backend.vault.package
        ];
        text = ''
          init_status="$(vault operator init \
            -status \
            -format=json \
            | jq -r '.Initialized'
          )"
          echo "$init_status"

          if [ "$init_status" == "true" ]; then
            echo "Vault already initialized. OK!"
            exit 0
          fi

          unseal_key="$(vault operator init \
            -key-shares=1 \
            -key-threshold=1 \
            -format=json \
            | jq -r '.unseal_keys_b64.[0]'
          )"
          echo "$unseal_key"

          unseal_status="$(vault operator unseal \
            -format=json \
            "$unseal_key" \
            | jq -r '.sealed'
          )"
          echo "$unseal_status"

          if ! [ "$unseal_status" = "false" ]; then 
            echo "Unseal did not work." 1>&2 
            exit 1
          fi

          echo "Unsealing done. Bye!"
        '';
      };
    };
  };

}
