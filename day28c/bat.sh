#!/usr/bin/env bash

export APPS_DIR=apps
export RESOURCE_DIR=resource

(cd kernel; make -j8)

for MK in $(ls apps/*/Makefile); do
    APP_DIR=$(dirname $MK)
    APP=$(basename $APP_DIR)
    make -C $APP_DIR $APP
done

pushd ../../edk2
rm MikanLoaderPkg  # remove symbolic link
ln -s ../MikanOS/day28c/MikanLoaderPkg
source edksetup.sh
#\rm -r Build
build

popd

#export QEMU_OPTS="-gdb tcp::12345"
#../../osbook/devenv/run_qemu.sh ../../edk2/Build/MikanLoaderX64/DEBUG_CLANG38/X64/Loader.efi kernel/kernel.elf apps/onlyhlt/onlyhlt
MIKANOS_DIR=$PWD ../../osbook/devenv/run_mikanos.sh
