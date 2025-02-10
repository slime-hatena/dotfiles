function _reload(){
  echo "Reloading..."
  source ~/.zshrc
  zle reset-prompt
}
zle -N _reload
