ABBR_SET_EXPANSION_CURSOR=1
ABBR_EXPANSION_CURSOR_MARKER='%'

abbr --session --quiet ll="ls -la"
abbr --session --quiet llt="ls -lat"
abbr --session --quiet gl="git log"
abbr --session --quiet "git mfeo"="git fetch && git merge --no-edit origin/%"

abbr --session --quiet tt="tmuximum"
abbr --session --quiet codi="code-insiders"

abbr --session --quiet .cd="cd ~/.local/share/chezmoi"
abbr --session --quiet .code="code ~/.local/share/chezmoi"
