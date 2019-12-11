LFS=${LFS:-/mnt/lfs}
SRCDIR=$LFS/sources

cleanup () {
	pkg=$1
	cd $SRCDIR
	if [[ -d $pkg ]]; then
		rm -rvf $pkg
	fi
}
untar () {
	pkg=$1

	echo ==== $pkg ====
	cleanup $pkg

	cd $SRCDIR
	tarflag=
	for file in $(ls $pkg*.tar.*); do
		echo $file
		if [[ $file = *.xz ]]; then
			tarflag=J
		elif [[ $file = *.bz2 ]]; then
			tarflag=j
		elif [[ $file = *.gz ]]; then
			tarflag=z
		else 
			echo "Could not find package"
			return 1
		fi
		tar x${tarflag}vf $file
	done

}


testit () {
	untar make-4.2.1
	untar tcl8.6.9
	untar elfutils-0.177
	untar mpfr-4.0.2

	cleanup make-4.2.1
	cleanup tcl8.6.9
	cleanup elfutils-0.177
	cleanup mpfr-4.0.2
}

testit


