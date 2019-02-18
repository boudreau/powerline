# My Custom [Powerline](https://github.com/powerline/powerline) Config

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
powerline_path=$(python -c 'import pkgutil; print pkgutil.get_loader("powerline").filename' 2>/dev/null)
if [[ "$powerline_path" != ""  ]]; then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  source ${powerline_path}/bindings/bash/powerline.sh
fi
```

To modify the Shell Prompt, check the colorschemes/shell/__main__.json or themes/shell/__main__.json 
To change colorscheme check the colorschemes/travis.json since that what we are using
