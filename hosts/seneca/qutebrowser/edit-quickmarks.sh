#!/usr/bin/env bash

# preserve X clipboard in temp variable
set old = $(xclip -sel clip -o)

# inject current QUTE_URL into the x clipboard
echo $QUTE_URL | xclip -sel clip

# open quickmarks in editor
kitty -e nvim /config/parts/home/programs/qutebrowser/quickmarks.nix

# once editor process finished, restore old X clipboard
${old} | xclip -sel clip

echo "message-info rebuilding..." >> "$QUTE_FIFO"

sudo nixos-rebuild switch

if [[ $? -eq 0 ]]
then
	echo 'message-info "rebuild successful!"' >> "$QUTE_FIFO"
else
	echo 'message-info "rebuild unsuccessful! (check :process)"' >> "$QUTE_FIFO"
fi



