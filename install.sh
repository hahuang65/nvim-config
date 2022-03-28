#/bin/sh

mkdir -p "${HOME}/.config/nvim"

if [ -f "${PWD}/init.lua" ]; then
  ln -sf "${PWD}/init.lua" "${HOME}/.config/nvim/init.lua"
elif [ -f "${PWD}/init.vim" ]; then
  ln -sf "${PWD}/init.vim" "${HOME}/.config/nvim/init.vim"
fi

ln -snf "${PWD}/lua" "${HOME}/.config/nvim/lua"
ln -snf "${PWD}/ftplugin" "${HOME}/.config/nvim/ftplugin"
