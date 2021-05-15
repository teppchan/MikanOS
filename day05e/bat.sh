#!/usr/bin/env bash

pushd ../../edk2
rm MikanLoaderPkg  # remove symbolic link
ln -s ../MikanOS/day05e/MikanLoaderPkg
source edksetup.sh
#\rm -r Build
build

popd
