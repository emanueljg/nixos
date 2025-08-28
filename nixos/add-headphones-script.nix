{ pkgs, ... }:
{

  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "major";
      runtimeInputs = [
        pkgs.util-linux
        pkgs.bluez
        pkgs.expect
      ];
      text = ''
        device="00:25:D1:4A:99:49"

        sudo rfkill unblock bluetooth
        sleep 1
        bluetoothctl power on
        bluetoothctl remove "$device"

        expect <(
        	cat <<EOF
        set timeout 60
        spawn bluetoothctl
        send -- "scan on\r"
        expect "$device"
        send -- "pair $device\r"
        expect "Pairing successful"
        send -- "connect $device\r"
        expect "Connection successful"
        send -- "trust $device\r"
        expect "trust succeeded"
        send -- "exit\r"
        expect eof
        EOF
        )
      '';
    })
  ];
}
