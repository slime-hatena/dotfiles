# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -n "$BASH_EXECUTION_STRING" ]; then
    # echo "> fish -c \"$BASH_EXECUTION_STRING\""
    fish -c "$BASH_EXECUTION_STRING"
    exit $?
fi

type brew >/dev/null 2>&1
if [ $? -eq 0 ]; then
    $(brew --prefix)/bin/fish
    if [ $? -eq 0 ]; then
        exit
    fi
    echo "fishの起動に失敗しました。インストールされているか、パスが通っているかを確認してください。"
else
    # Ubuntu Desktopなどでは発生するかも
    echo "fishの起動に失敗しました。brewが存在しませんでした。"
fi
