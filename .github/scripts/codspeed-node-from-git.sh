#!/usr/bin/env bash
set -ex

# This script allows the installation of a not yet released version of codspeed-node directly from the git repo.
# Usages ./scripts/codspeed-node-introspection.sh <branch>

BRANCH=$1

pushd ..

# Clone the repo if it doesn't exist or update it if it does
if [ ! -d "codspeed-node" ]; then
    git clone -b "$BRANCH" https://github.com/CodSpeedHQ/codspeed-node.git
else
    pushd codspeed-node
    git fetch origin "$BRANCH"
    git checkout "$BRANCH"
    git pull
    popd
fi

# Install dependencies and build the packages
sudo apt-get update
sudo apt-get install -y valgrind
pushd codspeed-node
pnpm i
pnpm moon run :build
sudo apt remove -y valgrind
popd

popd

# Install the built package
pnpm remove @codspeed/vitest-plugin
pnpm add --save-dev ../codspeed-node/packages/vitest-plugin
