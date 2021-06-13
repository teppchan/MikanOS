#!/usr/bin/env bash

pushd ../../edk2
rm MikanLoaderPkg  # remove symbolic link
ln -s ../MikanOS/day11a/MikanLoaderPkg
source edksetup.sh
#\rm -r Build
build

popd

../../osbook/devenv/run_qemu.sh ../../edk2/Build/MikanLoaderX64/DEBUG_CLANG38/X64/Loader.efi kernel/kernel.elf
#../../osbook/devenv/run_qemu.sh ../../edk2/Build/MikanLoaderX64/DEBUG_CLANG38/X64/Loader.efi ../mikanos/kernel/kernel.elf
