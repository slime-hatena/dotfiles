function fish_user_key_bindings
  # oh-my-fish/plugin-peco
  bind \ch 'peco_select_history (commandline -b)'
  # tsu-nera/fish-peco_recentd
  bind \cf 'peco_recentd'
  bind \cg '__peco_ghq_cd'
  bind \co 'finder'
  bind \cp '__open_code'
  bind \cb 'git-peco'
  bind \ct 'tmuximum'
  bind \cr 'reload'
  bind \cs 'tig status'
end