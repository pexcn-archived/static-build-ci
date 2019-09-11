#!/bin/bash -e

# timezone
export TZ=ROC

# non-interactive
export DEBIAN_FRONTEND=noninteractive
echo 'APT::Get::Assume-Yes "true";' | sudo tee -a /etc/apt/apt.conf.d/90non-interactive
echo 'DPkg::Options "--force-confnew";' | sudo tee -a /etc/apt/apt.conf.d/90non-interactive

# dependencies
sudo apt-get update
sudo apt-get install --no-install-recommends -y \
  build-essential gcc g++ make automake autoconf \
  libtool curl git
sudo apt-get clean
