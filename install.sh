#!/usr/bin/env bash

mkdir -p "${HOME}/.config/nvim"

if [ -f "${PWD}/init.lua" ]; then
	ln -sf "${PWD}/init.lua" "${HOME}/.config/nvim/init.lua"
elif [ -f "${PWD}/init.vim" ]; then
	ln -sf "${PWD}/init.vim" "${HOME}/.config/nvim/init.vim"
fi

ln -snf "${PWD}/lua" "${HOME}/.config/nvim/lua"
ln -snf "${PWD}/after" "${HOME}/.config/nvim/after"

for config in ./configs/*; do
	ln -sf "${PWD}/$config" "$HOME/.$(basename -- "$config")"
done
