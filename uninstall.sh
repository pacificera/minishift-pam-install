#!/bin/bash

minishift stop
minishift delete -f && rm -rf ~/.minishift/profiles/local-cluster-aa
brew cask uninstall minishift
brew uninstall docker-machine-driver-xhyve
brew uninstall --HEAD xhyve
