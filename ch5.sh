#! /bin/bash -x

source funcs.sh

#============================
start 5.11. tcl8.6.9
#----------------------------
untar tcl8.6.9
#--------
cd unix
./configure --prefix=/tools
make
TZ=UTC make test
make install
chmod -v u+w /tools/lib/libtcl8.6.so
make install-private-headers
ln -sv tclsh8.6 /tools/bin/tclsh
#--------
cleanup tcl8.6.9

#============================
start 5.12. expect-5.45.4
#----------------------------
untar expect-5.45.4
#--------
cp -v configure{,.orig}
sed 's:/usr/local/bin:/bin:' configure.orig > configure
./configure --prefix=/tools       \
            --with-tcl=/tools/lib \
            --with-tclinclude=/tools/include
make
make test
make SCRIPTS="" install
#--------
cleanup expect-5.45.4

#============================
start 5.13. dejagnu-1.6.2
#----------------------------
untar dejagnu-1.6.2
#--------
./configure --prefix=/tools
make install
make check
#--------
cleanup dejagnu-1.6.2

#============================
start 5.14. m4-1.4.18
#----------------------------
untar m4-1.4.18
#--------
sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c
echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h
./configure --prefix=/tools
make
make check
make install
#--------
cleanup m4-1.4.18

#============================
start 5.15. ncurses-6.1
#----------------------------
untar ncurses-6.1
#--------
sed -i s/mawk// configure
./configure --prefix=/tools \
            --with-shared   \
            --without-debug \
            --without-ada   \
            --enable-widec  \
            --enable-overwrite
make
make install
ln -s libncursesw.so /tools/lib/libncurses.so
#--------
cleanup ncurses-6.1

#============================
start 5.16. bash-5.0
#----------------------------
untar bash-5.0
#--------
./configure --prefix=/tools --without-bash-malloc
make
make tests
make install
ln -sv bash /tools/bin/sh
#--------
cleanup bash-5.0

#============================
start 5.17. bison-3.4.1
#----------------------------
untar bison-3.4.1
#--------
./configure --prefix=/tools
make
make check
make install
#--------
cleanup bison-3.4.1

#============================
start 5.18. bzip2-1.0.8
#----------------------------
untar bzip2-1.0.8
#--------
make
make PREFIX=/tools install
#--------
cleanup bzip2-1.0.8

#============================
start 5.19. coreutils-8.31
#----------------------------
untar coreutils-8.31
#--------
./configure --prefix=/tools --enable-install-program=hostname
make
make RUN_EXPENSIVE_TESTS=yes check
make install
#--------
cleanup coreutils-8.31

#============================
start 5.20. diffutils-3.7
#----------------------------
untar diffutils-3.7
#--------
./configure --prefix=/tools
make
make check
make install
#--------
cleanup diffutils-3.7

#============================
start 5.21. file-5.37
#----------------------------
untar file-5.37
#--------
./configure --prefix=/tools
make
make check
make install
#--------
cleanup file-5.37

#============================
start 5.22. findutils-4.6.0
#----------------------------
untar findutils-4.6.0
#--------
sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' gl/lib/*.c
sed -i '/unistd/a #include <sys/sysmacros.h>' gl/lib/mountlist.c
echo "#define _IO_IN_BACKUP 0x100" >> gl/lib/stdio-impl.h
./configure --prefix=/tools
make
make check
make install
#--------
cleanup findutils-4.6.0

#============================
start 5.23. gawk-5.0.1
#----------------------------
untar gawk-5.0.1
#--------
./configure --prefix=/tools
make
make check
make install
#--------
cleanup gawk-5.0.1

#============================
start 5.24. gettext-0.20.1
#----------------------------
untar gettext-0.20.1
#--------
./configure --disable-shared
make
cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /tools/bin
#--------
cleanup gettext-0.20.1

#============================
start 5.25. grep-3.3
#----------------------------
untar grep-3.3
#--------
./configure --prefix=/tools
make
make check
make install
#--------
cleanup grep-3.3

#============================
start 5.26. gzip-1.10
#----------------------------
untar gzip-1.10
#--------
./configure --prefix=/tools
make
make check
make install
#--------
cleanup gzip-1.10

#============================
start 5.27. make-4.2.1
#----------------------------
untar make-4.2.1
#--------
sed -i '211,217 d; 219,229 d; 232 d' glob/glob.c
./configure --prefix=/tools --without-guile
make
make check
make install
#--------
cleanup make-4.2.1

#============================
start 5.28. patch-2.7.6
#----------------------------
untar patch-2.7.6
#--------
./configure --prefix=/tools
make
make check
make install
#--------
cleanup patch-2.7.6

#============================
start 5.29. perl-5.30.0
#----------------------------
untar perl-5.30.0
#--------
sh Configure -des -Dprefix=/tools -Dlibs=-lm -Uloclibpth -Ulocincpth
make
cp -v perl cpan/podlators/scripts/pod2man /tools/bin
mkdir -pv /tools/lib/perl5/5.30.0
cp -Rv lib/* /tools/lib/perl5/5.30.0
#--------
cleanup perl-5.30.0

#============================
start 5.30. Python-3.7.4
#----------------------------
untar Python-3.7.4
#--------
sed -i '/def add_multiarch_paths/a \        return' setup.py
./configure --prefix=/tools --without-ensurepip
make
make install
#--------
cleanup Python-3.7.4

#============================
start 5.31. sed-4.7
#----------------------------
untar sed-4.7
#--------
./configure --prefix=/tools
make
make check
make install
#--------
cleanup sed-4.7

#============================
start 5.32. tar-1.32
#----------------------------
untar tar-1.32
#--------
./configure --prefix=/tools
make
make check
make install
#--------
cleanup tar-1.32

#============================
start 5.33. texinfo-6.6
#----------------------------
untar texinfo-6.6
#--------
./configure --prefix=/tools
make
make check
make install
#--------
cleanup texinfo-6.6

#============================
start 5.34. xz-5.2.4
#----------------------------
untar xz-5.2.4
#--------
./configure --prefix=/tools
make
make check
make install
#--------
cleanup xz-5.2.4


