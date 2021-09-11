# wingpanel-indicator-dark-style



```shell
meson build --prefix=/usr
cd build
# To install
sudo ninja install
# Install and run in debug mode
sudo ninja install && G_MESSAGES_DEBUG=all io.elementary.wingpanel | grep -i dark-style
```

### Generating translation files

```bash
# after setting up meson build
cd build

# generates pot file
ninja darkstyle-indicator-pot
ninja extra-pot

# to regenerate and propagate changes to every po file
ninja darkstyle-indicator-update-po
ninja extra-update-po
```