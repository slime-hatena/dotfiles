# fzf
bindkey "^g" _fzf_cd_ghq_with_git_fzf

bindkey "^b" __run_fzf_git_branches
bindkey "^s" _fzf_ssh
bindkey '^h' _fzf_history

bindkey "^r" _reload
bindkey "^t" _tmuximum

# disable default ^d
setopt IGNORE_EOF
bindkey "^d" _disable_ctrl_d
bindkey "^d^d^d^d^d" _exit
