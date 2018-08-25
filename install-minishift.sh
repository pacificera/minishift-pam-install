#/bin/bash
# see https://docs.okd.io/latest/minishift/getting-started/index.html
# for the installation outline followed by this script


# install xhyvie virtualization
brew update
brew install --HEAD xhyve

# configure xhyvie
brew install docker-machine-driver-xhyve
sudo chown root:wheel $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
sudo chmod u+s $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
brew info --installed docker-machine-driver-xhyve

# install minishift
brew cask install minishift
brew cask install --force minishift
