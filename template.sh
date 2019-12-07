LFS=${LFS:-/mnt/lfs}
SRCDIR=$LFS/sources

cleanup () {
	pkg=$1
	cd $SRCDIR
	[[ -d $pkg ]] && echo rm -rvf $pkg
}
untar () {
	pkg=$1

	cleanup $pkg

	cd $SRCDIR
	for file in $(ls $pkg*.tar.*); do
		echo $file
	if test -e $pkg*.tar.xz; then
		echo tar xJvf $pkg*.tar.xz
	elif test -e $pkg*.tar.bz2; then
		echo tar xjvf $pkg*.tar.bz2
	elif test -e $pkg*.tar.gz ; then
		echo tar xzvf $pkg*.tar.gz
	else 
		echo "Could not find package"
		return 1
	fi
	done

}


untar make-4.2.1
untar tcl8.6.9


