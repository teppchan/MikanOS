#!/usr/bin/env bash

pushd ../../edk2
rm MikanLoaderPkg  # remove symbolic link
ln -s ../MikanOS/day03a/MikanLoaderPkg
source edksetup.sh
build

popd