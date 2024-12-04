# fzf
bindkey "^g" _fzf_cd_ghq
bindkey "^b" _fzf_git_branch
bindkey "^s" _fzf_ssh
bindkey '^h' _fzf_history

bindkey "^r" _reload
bindkey "^t" _tmuximum
bindkey "^d" _disable_ctrl_d
setopt IGNORE_EOF # disable default ^d
bindkey "^d^d^d^d^d" _exit
