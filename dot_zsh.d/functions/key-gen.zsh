function key-gen() {
  local name="$1"

  if [[ -z "$name" ]]; then
    echo "Usage: key-gen <name>" >&2
    echo "  Generates an ed25519 SSH key pair as:" >&2
    echo "    private: ~/.ssh/keys/<name>" >&2
    echo "    public : ~/.ssh/keys/public/<name>.pub" >&2
    return 1
  fi

  if [[ "$name" == */* || "$name" == "." || "$name" == ".." ]]; then
    echo "Error: name must not contain '/' or be '.' / '..'." >&2
    return 1
  fi

  local private_path="$HOME/.ssh/keys/$name"
  local public_path="$HOME/.ssh/keys/public/$name.pub"

  if [[ -e "$private_path" ]]; then
    echo "Error: $private_path already exists." >&2
    return 1
  fi
  if [[ -e "$public_path" ]]; then
    echo "Error: $public_path already exists." >&2
    return 1
  fi

  mkdir -p "$HOME/.ssh/keys/public"

  ssh-keygen -t ed25519 -f "$private_path" -N "" -C "$(whoami)@$(hostname) for $name" || return $?

  # ssh-keygen places the public key alongside the private key.
  # Move it to the dedicated public/ directory to match the existing layout.
  mv "${private_path}.pub" "$public_path"

  echo
  echo "==== public key (${public_path}) ===="
  cat "$public_path"
  echo "====================================="
}
