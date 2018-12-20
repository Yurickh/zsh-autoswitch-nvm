function load_nvmrc() {
  if [[ -f package.json && -r package.json ]]; then
    echo "Checking for installed npm version..."
    range=$(node -p "(require('./package.json').engines || {}).node || 'none'")

    if [ $range = "none" ]; then
      echo "No node version specified in package.json."
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
  elif [[ $(nvm version) != $(nvm version default)  ]]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

if [[ -z "$DISABLE_AUTOSWITCH_NVM" ]]; then
    autoload -Uz add-zsh-hook
    add-zsh-hook -D chpwd load_nvmrc
    add-zsh-hook chpwd load_nvmrc

    load_nvmrc
fi
