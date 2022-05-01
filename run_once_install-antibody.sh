#!/bin/sh
if  command -v antibody >/dev/null 2>&1; then
	echo "antibody already installed"
else
curl -sfL git.io/antibody | sh -s - -b /usr/local/bin
fi

antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh
