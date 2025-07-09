#!/bin/bash

export XDG_RUNTIME_DIR="/run/user/1000"
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

SINK1="alsa_output.pci-0000_00_1f.3.analog-stereo"
SINK2="alsa_output.pci-0000_01_00.1.hdmi-stereo"

CURRENT=$(pactl get-default-sink)

if [ "$CURRENT" = "$SINK1" ]; then
    pactl set-default-sink "$SINK2"
    NEW="$SINK2"
else
    pactl set-default-sink "$SINK1"
    NEW="$SINK1"
fi

for INPUT in $(pactl list short sink-inputs | cut -f1); do
    pactl move-sink-input "$INPUT" "$NEW"
done

notify-send "Audio Output Changed" "Switched to $(echo "$NEW" | grep -oP '(\w+)-stereo' | sed 's/-stereo//')"