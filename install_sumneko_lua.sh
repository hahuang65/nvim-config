#/bin/sh

if command -v ninja &> /dev/null
then
  if [ $(uname) == "Linux" ]
  then
    OS='linux'
  elif [ $(uname) == "Darwin" ]
  then
    OS="macos"
  else
    echo "OS $OS isn't supported. Aborting."
    exit 1
  fi

  echo "Installing sumneko_lua..."

  mkdir -p "${HOME}/.cache/nvim"
  SUMNEKO_DIR="${HOME}/.cache/nvim/lua-language-server"

  if [ ! -d "$SUMNEKO_DIR" ]
  then
    git clone https://github.com/sumneko/lua-language-server "$SUMNEKO_DIR"
    cd "$SUMNEKO_DIR"
    git submodule update --init --recursive
  fi

  cd "$SUMNEKO_DIR"
  pushd 3rd/luamake

  if [ ! -d build ]
  then
    ninja -f "compile/ninja/${OS}.ninja"
  fi

  popd

  if [ ! -d bin ]
  then
    ./3rd/luamake/luamake rebuild
  fi
else
  echo "\`ninja\` is not installed. Aborting."
  exit 1
fi
