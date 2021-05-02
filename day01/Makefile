

hello.efi: hello.c
	clang -target x86_64-pc-win32-coff \
	-mno-red-zone -fno-stack-protector -fshort-wchar -Wall -c hello.c
	lld-link-6.0 /subsystem:efi_application /entry:EfiMain /out:hello.efi hello.o

