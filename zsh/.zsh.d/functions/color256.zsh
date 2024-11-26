function color256() {
  zsh  <<< 'for code in {000..255}; do print -nP -- "%F{$code}$code%f "; [ $((${code} % 16)) -eq 15 ] && echo; done'
  echo
  zsh  <<< 'for code in {000..255}; do print -nP -- "%K{$code}$code%k "; [ $((${code} % 16)) -eq 15 ] && echo; done'
}
