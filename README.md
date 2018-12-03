# Autoswitch Node nvm version

_zsh-autoswitch-nvm_ is a simple package that switches your nvm version when you cd into a directory with a package.json.

## Caveats

- This package won't check for `.nvmrc` files, since nvm checks for it automatically already.
- You'll need the [semver](https://www.npmjs.com/package/semver) package installed globally.

## Installing

By hand

```bash
git clone https://github.com/Yurickh/zsh-autoswitch-nvm ~/.dotfiles/lib/zsh-autoswitch-nvm
echo 'source ~/.dotfiles/lib/zsh-autoswitch-nvm/autoswitch_nvm.plugin.zsh' >> ~/.zshrc
```

I'm not currently aware of how to link this package to any package manager, so I don't know if you can use them to install it.

## Updating

For the time being, the best way to update is to `cd` into the package and `pull` the latest version:

```bash
cd ~/.dotfiles/lib/zsh-autoswitch-nvm
git pull origin master
```

## Deactivating

Set the `DISABLE_AUTOSWITCH_NVM` variable to temporarily disable version switching when loading a new terminal window.
