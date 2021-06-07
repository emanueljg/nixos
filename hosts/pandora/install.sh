loadkeys sv-latin1

SDX=/dev/sda

sgdisk -Z
sgdisk -n 0:0:+512MiB -t 0:ef00 -c 0:efi  $SDX
sgdisk -n 0:0:+8GiB   -t 0:8200 -c 0:swap $SDX
sgdisk -n 0:0:0       -t 0:8300 -c 0:root $SDX
sgdisk -p $SDX

mkfs.fat -F 32 -n efi  ${SDX}1
mkswap         -L swap ${SDX}2
mkfs.ext4      -L root ${SDX}3

mount /dev/disk/by-label/root /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/efi /mnt/boot
swapon ${SDX}2

nixos-generate-config --root /mnt

# . . .

nixos-install
reboot
