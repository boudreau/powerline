# My Custom [Powerline](https://github.com/powerline/powerline) Config

## Quick setup

`setup-powerline.sh` does everything below in one go: it installs powerline-status and
powerline-gitstatus in a Python 3 venv at `~/.venvs/powerline`, clones this repo to
`~/.config/powerline`, and adds the loader to `~/.bashrc` (after backing it up). It needs
`python3` and `git`, and is safe to re-run.

```shell
curl -fsSL https://raw.githubusercontent.com/boudreau/powerline/master/setup-powerline.sh | bash
```

Or, if this repo is already cloned to `~/.config/powerline`:

```shell
~/.config/powerline/setup-powerline.sh
```

## Manual setup

For Unix be sure to install pip

```shell
sudo easy_install pip
```

Install powerline-status with the --user option

```shell
pip install --user powerline-status
```

Add the pip executables directory to your path

```shell
export PATH=~/.local/bin:$PATH
```

Clone this repo to your ~/.config directory

```shell
git clone https://github.com/boudreau/powerline.git ~/.config/powerline
```

Use the following shell script to start up powerline in .bashrc

```shell
powerline_path=$(python3 -c 'import os, powerline; print(os.path.dirname(powerline.__file__))' 2>/dev/null)
if [[ "$powerline_path" != ""  ]]; then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  source ${powerline_path}/bindings/bash/powerline.sh
fi
```

To modify the Shell Prompt, check the colorschemes/shell/__main__.json or themes/shell/__main__.json 
###
To change colorscheme check the colorschemes/travis.json since that what we are using
###
To have the GIT status at the end of the prompt, we need to install :

```shell
pip install powerline-gitstatus
```
