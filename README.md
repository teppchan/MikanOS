# ゼロからのOS自作入門

## 2021/05/01 （1日目）

WSLのUbuntu 18.04で作業。

開発環境は以下の通り。
- Windows10
- Ubuntu 18.04 on WSL2
- Visual Studio Code

```bash
$ sudo apt update && sudo apt upgrade
$ sudo apt install qemu
```

BZで謎の数列を書く。

```shell
$ hexdump -C BOOTX64.EFI
00000000  4d 5a 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |MZ..............|
00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000030  00 00 00 00 00 00 00 00  00 00 00 00 80 00 00 00  |................|
00000040  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000080  50 45 00 00 64 86 02 00  00 00 00 00 00 00 00 00  |PE..d...........|
00000090  00 00 00 00 f0 00 22 02  0b 02 00 00 00 02 00 00  |......".........|
000000a0  00 02 00 00 00 00 00 00  00 10 00 00 00 10 00 00  |................|
000000b0  00 00 00 40 01 00 00 00  00 10 00 00 00 02 00 00  |...@............|
000000c0  00 00 00 00 00 00 00 00  06 00 00 00 00 00 00 00  |................|
000000d0  00 30 00 00 00 02 00 00  00 00 00 00 0a 00 60 81  |.0............`.|
000000e0  00 00 10 00 00 00 00 00  00 10 00 00 00 00 00 00  |................|
*
00000100  00 00 00 00 10 00 00 00  00 00 00 00 00 00 00 00  |................|
00000110  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000180  00 00 00 00 00 00 00 00  2e 74 65 78 74 00 00 00  |.........text...|
00000190  14 00 00 00 00 10 00 00  00 02 00 00 00 02 00 00  |................|
000001a0  00 00 00 00 00 00 00 00  00 00 00 00 20 00 50 60  |............ .P`|
000001b0  2e 72 64 61 74 61 00 00  1c 00 00 00 00 20 00 00  |.rdata....... ..|
000001c0  00 02 00 00 00 04 00 00  00 00 00 00 00 00 00 00  |................|
000001d0  00 00 00 00 00 00 50 40  00 00 00 00 00 00 00 00  |......P@........|
000001e0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000200  48 83 ec 28 48 8b 4a 40  48 8d 15 f1 0f 00 00 ff  |H..(H.J@H.......|
00000210  51 08 eb fe 00 00 00 00  00 00 00 00 00 00 00 00  |Q...............|
00000220  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000400  48 00 65 00 6c 00 6c 00  6f 00 2c 00 20 00 77 00  |H.e.l.l.o.,. .w.|
00000410  6f 00 72 00 6c 00 64 00  21 00 00 00 00 00 00 00  |o.r.l.d.!.......|
00000420  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000600
$ sum BOOTX64.EFI
12430     2
```

作った謎ファイルを使ってイメージファイルを作る。

```shell
$ qemu-img create -f raw disk.img 200M
Formatting 'disk.img', fmt=raw size=209715200
$ mkfs.fat -n 'MIKAN OS' -s 2 -f 2 -R 32 -F 32 disk.img
mkfs.fat 4.1 (2017-01-24)
$ mkdir -p mnt
$ sudo mount -o loop disk.img mnt
$ sudo mkdir -p mnt/EFI/BOOT
$ sudo cp BOOTX64.EFI mnt/EFI/BOOT/BOOTX64.EFI
```

WSLで必要なファイルを取ってくる。

```shell
$ git clone https://github.com/uchan-nos/mikanos-build.git osbook
```

VcXsrvを起動しておく。
ウィンドウを出すには、WSLのIPアドレスがXXX.YYY.ZZZ.AAAとすると、

```shell
$ export DISPLAY=XXX.YYY.ZZZ.AAA:0.0
```
と設定しておく。

```shell
$ qemu-system-x86_64 \
  -drive if=pflash,file=/mnt/e/work_dir/os/osbook/devenv/OVMF_CODE.fd \
  -drive if=pflash,file=/mnt/e/work_dir/os/osbook/devenv/OVMF_VARS.fd \
  -hda disk.img
```

なんかでた。

![qemuのウィンドウ](img/2021-05-02-00-10-32.png)

## 2021/05/02 （2日目）

p.43の`hello.c`を準備。

開発環境が入っていなかったのでインストール。

```sh
$ sudo apt install build-essential
$ sudo apt install clang lld
```

`Makefile`を準備していざコンパイルしようとしたけど、やっぱりエラーが出た。
`EFI_STATUS`の定義がないから変だと思ってた。開発環境に入ってた`hello.c`を見たら、いろいろ定義が入ってた。
確かに本文を読むと、`EfiMain`だけ取り出して説明していることになってた。

```cpp:hello.c
typedef unsigned short CHAR16;
typedef unsigned long long EFI_STATUS;
typedef void *EFI_HANDLE;

struct _EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL;
typedef EFI_STATUS (*EFI_TEXT_STRING)(
  struct _EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL  *This,
  CHAR16                                   *String);

typedef struct _EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL {
  void             *dummy;
  EFI_TEXT_STRING  OutputString;
} EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL;

typedef struct {
  char                             dummy[52];
  EFI_HANDLE                       ConsoleOutHandle;
  EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL  *ConOut;
} EFI_SYSTEM_TABLE;

EFI_STATUS EfiMain(EFI_HANDLE        ImageHandle,
                   EFI_SYSTEM_TABLE  *SystemTable) {
  SystemTable->ConOut->OutputString(SystemTable->ConOut, L"Hello, world!\n");
  while (1);
  return 0;
}
```

昨日はNTFSで作ったディレクトリ`mnt`をマウントポイントに設定できてたのに、今日はできない。
昨日はWSL2の環境で動かしてたのに対し、いまWSL1の環境で作業してる。これが原因？

`osbook/devenv/run_emu.sh` を使って実行してもうまくいかなかった。

WSL2に変更した

```shell
> wsl --set-version Ubuntu-18.04 2
```

```sh
$ cd day01
$ make hello.efi
$ ./run_hello.sh
```

![hello.efiで起動したQEMU](img/2021-05-02-14-49-02.png)

でた！

## 2021/05/03 （3日目）

開発環境をセットしきってなかった。
`https://github.com/uchan-nos/mikanos-build.git` の `devenv/ansible-provision.yml` にセットアップ方法がまとまってた。`ansible`を使う手順が書いてあったけど、中身を見て自分で打ち込んでみる。

```sh
$ sudo apt install build-essential llvm-7-dev lld-7 clang-7 nasm acpica-tools u
uid-dev qemu-system-x86 qemu-utils xauth unzip python3-distutils
$ cd osbook/devenv
$ git clone https://github.com/tianocore/edk2.git
$ cd edk2
$ git checkout -b 38c8be123aced4cc8ad5c7e0da9121a181b94251
$ cd ..
$ wget https://github.com/uchan-nos/mikanos-build/releases/download/v2.0/x86_64-elf.tar.gz
$ tar xf x86_64-elf.tar.gz
```

`clang-7`という感じでバージョン番号がついているファイルを、ついてないファイルにシンボリックしなおしていたので、`day02/rename_ln.sh`で対処した。

```sh
$ sudo day02/rename_ln.sh
```

これで開発環境ができた。

あとこれを、`.profile`に追加しておくと、Xウィンドウが出てくるようになる。
```
export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
```

2日目のデータ（`osbook_day02a`）を取り出すために、`Mikan OS`のリポジトリを取ってくる。

```sh
$ git clone https://github.com/uchan-nos/mikanos.git
```

```sh
$ cd mikanos
$ git checkout -b osbook_day02a
```

せっかくなので写経してみる。。。

`PACKAGE_GUID`は自分で作ったのを使ってみる。`uuidgen`というのが使えた。

```sh
$ uuidgen
dbe19b51-65ba-4b01-a8cd-b194af164088
```

写経したのでコンパイルしてみる。
さっきダウンロードした`edk2`の環境に、写経したファイルの入っているディレクトリのシンボリックリンクを作る。

```sh
$ cd osbllk/devenv/edk2
$ ln -s ../../../day02/MikanLoaderPkg .
```

開発環境にある`edksetup.sh`を読み込む。`conf`の下にファイルができる。
```sh
$ source edksetup.sh
$ ls Conf
BuildEnv.sh  ReadMe.txt  build_rule.txt  target.txt  tools_def.txt
```

`Conf/target.txt`を編集する。変更する箇所は下記の4か所。

- ACITVE_PLATFORM = MikanLoaderPkg/MikanLoaderPkg.sdc
- TARGET = DEBUG
- TARGET_ARCH = X64
- TOOL_CHAIN_TAG = CLANG38

ビルドする。

```sh
$ pwd
.../osbook/devenv/edk2
$ build
```

写経のTypoを直したりしたら、こんなエラーがでた。

```
BaseTools C Tool binary was not found (GenFw)
You may need to run:
  make -C xxxxx/BaseTools/Source/C
```

いう通りrunしてみたら、
```
BrotliCompress.c:20:10: fatal error: ./brotli/c/common/constants.h: No such file or directory
 #include "./brotli/c/common/constants.h"
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
compilation terminated.
../Makefiles/footer.makefile:21: recipe for target 'BrotliCompress.o' failed
make[1]: *** [BrotliCompress.o] Error 1
```

というエラーになった。
`ansible_provision.yml`を見直したら、いくつか手順を抜かしてた。

- `git clone`するとき`--recursive`を付けてなかった
  - `git submodule update --init --recursive` で対処
- ツールのコンパイル
  - `cd edk2/BaseTools/Source/C; make`

分からなくなるので環境の構築手順をまとめなおす。
すなおに`ansible`使えばよかった、、、

```sh
$ sudo apt install build-essential llvm-7-dev lld-7 clang-7 nasm acpica-tools u
uid-dev qemu-system-x86 qemu-utils xauth unzip python3-distutils
$ sudo day02/rename_ln.sh
$ cd osbook/devenv
$ git clone --recursive https://github.com/tianocore/edk2.git
$ cd edk2
$ git checkout -b 38c8be123aced4cc8ad5c7e0da9121a181b94251
$ cd BaseTools/Source/C
$ make
$ cd -
$ cd ..
$ wget https://github.com/uchan-nos/mikanos-build/releases/download/v2.0/x86_64-elf.tar.gz
$ tar xf x86_64-elf.tar.gz
```

`build`しなおしたらBUILDに成功した。

```sh
$ ../run_qemu.sh Build/MikanLoaderX64/DEBUG_CLANG38/X64/Loader.efi
```

![EDK2環境でビルドしたLoader.efi](img/2021-05-03-13-48-27.png)

でた。