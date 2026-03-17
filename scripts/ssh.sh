#!/usr/bin/env bash

echo "Executing ssh.sh"

mkdir -p ~/.ssh
touch ~/.ssh/local_settings
mkdir -p ~/.ssh/keys
mkdir -p ~/.ssh/keys/public

mkdir -p -m 700 ~/.ssh
mkdir -m 700 -p ~/.ssh/keys

echo "Finished executing ssh.sh"
