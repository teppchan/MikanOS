#!/usr/bin/env bash

pushd ../../edk2
rm MikanLoaderPkg  # remove symbolic link
ln -s ../MikanOS/day06c/MikanLoaderPkg
source edksetup.sh
#\rm -r Build
build

popd
