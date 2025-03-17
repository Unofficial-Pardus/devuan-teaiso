#!/usr/bin/env bash

### Drop no-recommend
rm /etc/apt/apt.conf.d/01norecommend

### fake systemctl (for nosystemd)
ln -s true /bin/systemctl || true

cd /tmp
# ostree cannot detect boot id
export OSTREE_BOOTID="$(echo $RANDOM | md5sum -)"
set -ex

### Instally 17g and other stuff
yes | apt install wget

wget https://github.com/03tekno/debhane/raw/main/17g-installer_1.0_all.deb
wget https://github.com/03tekno/debhane/raw/main/pardus-package-installer_0.6.2_all.deb
wget https://github.com/03tekno/debhane/raw/main/pipewire-launcher_1.0.0_all.deb
yes | apt install ./*.deb -yq --allow-downgrades

install -d -m 0755 /etc/apt/keyrings
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null
echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' | tee /etc/apt/preferences.d/mozilla
apt update && apt install firefox firefox-l10n-tr -y
