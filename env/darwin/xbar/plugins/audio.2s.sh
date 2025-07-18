#!/usr/bin/env bash

outputDevice=$(/usr/local/bin/SwitchAudioSource -c -t output)
inputDevice=$(/usr/local/bin/SwitchAudioSource -c -t input)

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

echo "🔊" $outputDevice " / 🎤" $inputDevice
