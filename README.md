## Installation

Installation and the dotfiles are to be managed with [yadm](https://yadm.io/), thus installation is done through cloning the repository using `yadm clone`, and then confirm running the bootstrapping script when prompted to. If not prompted after cloning, executing the bootstrapping script can be done at any time with `yadm bootstrap`.

Thus, if you have a completely fresh install of Arch Linux, do the following:

```sh
curl -fLo /usr/local/bin/yadm https://github.com/TheLocehiliosan/yadm/raw/master/yadm && chmod a+x /usr/local/bin/yadm
yadm clone https://github.com/Krismix1/dotfiles
yadm bootstrap
```

### Post-bootstrap steps:

- Configure SSH keys + hosts
- Update Polybar configuration for your environment (update network interfaces, battery module, backlight module)
