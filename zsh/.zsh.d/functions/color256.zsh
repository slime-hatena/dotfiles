function color256() {
  zsh  <<< 'for code in {000..255}; do print -nP -- "%F{$code}$code%f "; [ $((${code} % 16)) -eq 15 ] && echo; done'
  echo
  zsh  <<< 'for code in {000..255}; do print -nP -- "%F{0}%K{$code}$code%k%f "; [ $((${code} % 16)) -eq 15 ] && echo; done'
  echo
  zsh  <<< 'for code in {000..255}; do print -nP -- "%F{7}%K{$code}$code%k%f "; [ $((${code} % 16)) -eq 15 ] && echo; done'
}
