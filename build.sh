#!/bin/bash

#make native directory if it doesn't exist
if [[ ! -e "native" ]]; then
    mkdir "native"
fi

#make target directory if it doesn't exist
if [[ ! -e "target" ]]; then
    mkdir "target"
fi


case "$1" in
    'linux')
	# wget https://github.com/supercollider/supercollider/releases/download/Version-3.8.0/SuperCollider-3.8.0-Source-linux.tar.bz2 -P target
	# tar jfx target/SuperCollider-3.8.0-Source-linux.tar.bz2 -C target
	
	echo "Fetch submodules"
	git submodule update --init --recursive
	cd target
	rm -rf scmake scmake-extras fftw-3.3.7
	mkdir scmake scmake-extras libsndfile-build
        cd libsndfile-build
        cmake ../../libsndfile
        make
        cd ../
        wget -nc http://fftw.org/fftw-3.3.7.tar.gz
        tar -xvf fftw-3.3.7.tar.gz
        cd fftw-3.3.7
        mkdir build
        cd build
        sh ../configure --enable-float --enable-shared
        make
        # make install DESTDIR=`pwd`
        # -DSNDFILE_LIBRARY=`pwd`/../libcsound-build/libsndfile \
        # -DFFTW3F_LIBRARY=`pwd`/../fftw-3.3.7/build/.libs/libfftw3
        # -DSNDFILE_INCLUDE_DIR:STRING="../../libsndfile/src"  \
	cd ../scmake
	cmake ../../supercollider -DSUPERNOVA:BOOL=OFF -DSC_IDE:BOOL=OFF -DLIBSCSYNTH:BOOL=ON \
                                  -DSNDFILE_LIBRARY:STRING="`cd ..;pwd`/libsndfile-build/libsndfile.so" \
                                  -DFFTW3F_LIBRARY="`cd ..;pwd`/fftw-3.3.7/build/.libs/libfftw3f.so" \
                                  -DFFTW3F_INCLUDE_DIR:STRING="../fftw-3.3.7/api"
	make -j6
	cd ../scmake-extras
	cmake ../../sc3-plugins -DSUPERNOVA:BOOL=OFF -DSC_PATH=../../supercollider
	make -j6
	cd ../../native
	rm -rf linux
	mkdir linux linux/x86_64
	cd linux/x86_64
	echo "Copy artifacts to native/linux"
	cp ../../../target/scmake/server/scsynth/*.so* ./
	cp ../../../target/scmake/server/plugins/*.so ./
	cp ../../../target/scmake-extras/source/*.so ./
	cp ../../../target/scmake-extras/source/StkInst/*.so ./
	echo "Finish"
	;;

        'macosx')
	echo "Fetch submodules"
	git submodule update --init --recursive
	cd target
	rm -rf scmake scmake-extras
	mkdir scmake scmake-extras
	cd scmake
	cmake ../../supercollider -G Xcode -DCMAKE_PREFIX_PATH=`brew --prefix qt55` -DSUPERNOVA:BOOL=OFF -DLIBSCSYNTH:BOOL=ON
	cmake --build . --config Release
	cd ../scmake-extras
	cmake ../../sc3-plugins -DSC_PATH=../../supercollider
	cmake --build . --config Release
	cd ../../native
	rm -rf macosx
	mkdir macosx macosx/x86_64
	cd macosx/x86_64
	echo "Copy artifacts to native/macosx"
	cp ../../../target/scmake/server/scsynth/Release/*.dylib* ./
	cp ../../../target/scmake/server/plugins/Release/*.scx ./
	cp ../../../target/scmake-extras/source/*.scx ./
	cp ../../../target/scmake-extras/source/StkInst/*.scx ./
	echo "Finish"
	;;
esac
