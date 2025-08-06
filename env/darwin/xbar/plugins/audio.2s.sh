#!/usr/bin/env bash

# Determine the correct brew path based on architecture
if [ "$(uname -m)" == 'arm64' ]; then
    BREW_PREFIX="/opt/homebrew"
else
    BREW_PREFIX="/usr/local"
fi

SWITCH_AUDIO="$BREW_PREFIX/bin/SwitchAudioSource"

outputDevice=$($SWITCH_AUDIO -c -t output)
inputDevice=$($SWITCH_AUDIO -c -t input)

# Check if outputDevice is empty
if [ -z "$outputDevice" ]; then
  outputDevice="No output device found"
fi

if [[ "$outputDevice" == "MacBook Proのスピーカー" ]]; then
  outputDevice="built-in"
fi

if [ -z "$inputDevice" ]; then
  inputDevice="No input device found"
fi

if [[ "$inputDevice" == "MacBook Proのマイク" ]]; then
  inputDevice="built-in"
fi

allOutputDevices=$($SWITCH_AUDIO -a -t output)
allInputDevices=$($SWITCH_AUDIO -a -t input)

echo "🔊" $outputDevice " / 🎤" $inputDevice

echo "---"

echo "Output Devices"
while IFS= read -r line; do
  echo "-- $line | bash='$SWITCH_AUDIO' param1='-t' param2='output' param3='-s' param4='$line' terminal=false"
done <<< "$allOutputDevices"

echo "Input Devices"
while IFS= read -r line; do
  echo "-- $line | bash='$SWITCH_AUDIO' param1='-t' param2='input' param3='-s' param4='$line' terminal=false"
done <<< "$allInputDevices"
