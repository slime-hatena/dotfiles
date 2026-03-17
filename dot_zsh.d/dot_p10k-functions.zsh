function prompt_dir_ignore_git() {
  dir=$(pwd)
  if [ "$dir" = "$HOME" ]; then
    p10k segment -b 4 -f 7 -i '' -t "~"
    return 0
  fi

  dir="${dir/$HOME/~}"
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    git_dir="/$(git rev-parse --show-prefix)"
    git_dir=${${git_dir}%/}
    dir="${dir/$git_dir/""}"
  fi

  p10k segment -b 4 -f 7 -t $dir
  # p10k segment -b 4 -f 7 -i '' -t $dir // optional.
}

function prompt_dir_only_git() {
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    p10k segment -b 4 -f 7 -t "/$(git rev-parse --show-prefix)"
  fi
}
