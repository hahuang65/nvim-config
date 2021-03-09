#!/bin/sh

mkdir -p "${HOME}/.config/nvim"

ln -sf "${PWD}/init.vim" "${HOME}/.config/nvim/init.vim"
ln -sf "${PWD}/lua" "${HOME}/.config/nvim/lua"
