function read_node_range() {
  range="none"

  if [[ -f .node-version && -r .node-version ]]; then
    range=$(cat .node-version)
  fi

  if [ $range = "none" ]; then
    if [[ -f package.json && -r package.json ]]; then
      range=$(node -p "(require('./package.json').engines || {}).node || 'none'")
    fi
  fi

  echo $range
}

function load_nvmrc() {
  echo "Checking for installed npm version..."
  range=`read_node_range`

  if [ $range = "none" ]; then
    echo "No node version configured in workspace."
    nvm use default
  else
    version=$(semver -r $range $(nvm ls --no-colors | grep -v " ->" | xargs | tr -d '*\->') | tail -n 1)
    nvm use $version > /dev/null 2>&1

    if [ $? != 0 ]; then
      available=$(semver -r $range $(nvm ls-remote --no-colors | grep -oE '.*?v[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+' | xargs ) | tail -n 1)
      echo "Couldn't find local version in range $range, downloading version $available"
      nvm install $available

      if [ $? != 0 ]; then
        echo "Couldn't install version $available"
      fi
    fi
  fi
}

if [[ -z "$DISABLE_AUTOSWITCH_NVM" ]]; then
    autoload -Uz add-zsh-hook
    add-zsh-hook -D chpwd load_nvmrc
    add-zsh-hook chpwd load_nvmrc

    load_nvmrc
fi
