#!/usr/bin/env bash

for f in \
llvm-PerfectShuffle \
llvm-ar \
llvm-as \
llvm-bcanalyzer \
llvm-cat \
llvm-cfi-verify \
llvm-config \
llvm-cov \
llvm-c-test \
llvm-cvtres \
llvm-cxxdump \
llvm-cxxfilt \
llvm-diff \
llvm-dis \
llvm-dlltool \
llvm-dwarfdump \
llvm-dwp \
llvm-exegesis \
llvm-extract \
llvm-lib \
llvm-link \
llvm-lto \
llvm-lto2 \
llvm-mc \
llvm-mca \
llvm-modextract \
llvm-mt \
llvm-nm \
llvm-objcopy \
llvm-objdump \
llvm-opt-report \
llvm-pdbutil \
llvm-profdata \
llvm-ranlib \
llvm-rc \
llvm-readelf \
llvm-readobj \
llvm-rtdyld \
llvm-size \
llvm-split \
llvm-stress \
llvm-strings \
llvm-strip \
llvm-symbolizer \
llvm-tblgen \
llvm-undname \
llvm-xray \
ld.lld \
lld-link \
clang \
clang++ \
clang-cpp \
; do 

echo $f
ln -s /usr/bin/${f}-7 /usr/bin/$f

done