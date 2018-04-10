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
	git submodule init && git submodule update
	cd supercollider
	git submodule init && git submodule update
	cd ../sc3-plugins/
	git submodule init && git submodule update
	cd ../target
	rm -rf scmake scmake-extras
	mkdir scmake scmake-extras
	cd scmake
	cmake ../../supercollider -DSUPERNOVA:BOOL=OFF -DLIBSCSYNTH:BOOL=ON
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
	git submodule init && git submodule update
	cd supercollider
	git submodule init && git submodule update
	cd ../sc3-plugins/
	git submodule init && git submodule update
	cd ../target
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
