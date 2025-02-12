# slime-hatena/dotfiles

[![Latest version](https://img.shields.io/github/v/release/slime-hatena/dotfiles?style=for-the-badge)](https://github.com/slime-hatena/dotfiles/releases/latest)

🍮こんな環境で作業しています

## Install (bash)

### main

```sh
/bin/bash -c "$(curl -fsSL https://git.io/dot-slime-hatena)"
```

### develop

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Slime-hatena/dotfiles/develop/scripts/clone.sh) develop"
```

## Install (Windows)

### main

```ps1
Invoke-WebRequest "https://raw.githubusercontent.com/slime-hatena/dotfiles/develop/windows/winget.ps1" -OutFile "C:\Windows\Temp\winget.ps1"
powershell -NoProfile -ExecutionPolicy Unrestricted "C:\Windows\Temp\winget.ps1"
```

## test

```bash
docker build -t dotfiles_test:local -f ./Dockerfile .
docker run -it dotfiles_test:local
```
