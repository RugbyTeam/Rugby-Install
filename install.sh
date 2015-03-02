#! /bin/bash

# install vagrant and virtualbox
# install dpkg and virtualbox
sudo apt-get install dpkg-dev virtualbox-dkms

# install vagrant
VAGRANT_URL="https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.2_x86_64.deb"
VAGRANT_PACKAGE="vagrant.deb"

wget "$VAGRANT_URL" -v -O "$VAGRANT_PACKAGE"
sudo dpkg -i "$VAGRANT_PACKAGE"
rm "$VAGRANT_PACKAGE"

# install linux headers
KERNEL_VERSION=$(uname -r)
sudo apt-get install "linux-headers-$KERNEL_VERSION"

sudo dpkg-reconfigure virtualbox-dkms

# install python-dev and pip
sudo apt-get install python-dev

# install pip
PIP_URL="https://bootstrap.pypa.io/get-pip.py"
wget -qO- "$PIP_URL" | sudo python -

# install virtualenv
sudo pip install virtualenv

RUGBY_BASE_PATH="/opt"
RUGBY_APP="$RUGBY_BASE_PATH/Rugby-App"
RUGBY_CORE="$RUGBY_APP/Rugby-Core"
RUGBY_SERVER="$RUGBY_APP/Rugby-Server"
RUGBY_TESTS="$RUGBY_APP/Rugby-Tests"
RUGBY_PLAYBOOKS="$RUGBY_APP/Rugby-Playbooks"

sudo mkdir -p "$RUGBY_APP"

# install git
sudo apt-get install git

# Clone project repos
sudo git clone https://github.com/RugbyTeam/Rugby "$RUGBY_CORE"
sudo git clone https://github.com/RugbyTeam/Rugby-Server "$RUGBY_SERVER"
sudo git clone https://github.com/RugbyTeam/Rugby-Tests "$RUGBY_TESTS"
sudo git clone https://github.com/RugbyTeam/Rugby-Playbooks "$RUGBY_PLAYBOOKS"

# create and activate virtualenv
virtualenv "$RUGBY_CORE/venv"
. "$RUGBY_CORE/venv/bin/activate"

# install dependencies
export PYTHONPATH="$RUGBY_CORE"
pip install -r "$RUGBY_CORE/requirements.txt"
pip install -r "$RUGBY_SERVER/requirements.txt"

# apply patch to vagrant
TO_PATCH="$PYTHONPATH/venv/lib/python2.7/site-packages/vagrant/__init__.py"
PATCH="$PYTHONPATH/patches/vagrant_quiet_logging_issue.patch"
patch "$TO_PATCH" < "$PATCH"

