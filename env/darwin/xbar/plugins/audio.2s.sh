#!/usr/bin/env bash

outputDevice=$(/opt/homebrew/bin/SwitchAudioSource -c -t output)
inputDevice=$(/opt/homebrew/bin/SwitchAudioSource -c -t input)

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

allOutputDevices=$(/opt/homebrew/bin/SwitchAudioSource -a -t output)
allInputDevices=$(/opt/homebrew/bin/SwitchAudioSource -a -t input)

echo "🔊" $outputDevice " / 🎤" $inputDevice

echo "---"

echo "Output Devices"
while IFS= read -r line; do
  echo "-- $line | bash='/opt/homebrew/bin/SwitchAudioSource' param1='-s' param2='$line' terminal=false"
done <<< "$allOutputDevices"

echo "Input Devices"
while IFS= read -r line; do
  echo "-- $line | bash='/opt/homebrew/bin/SwitchAudioSource' param1='-s' param2='$line' terminal=false"
done <<< "$allInputDevices"
