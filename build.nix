{ stdenv, pkgs }:

let optional = stdenv.lib.optional;
in

stdenv.mkDerivation rec {
  name = "supercollider-${version}";
  version = "3.10.2";

  src = pkgs.fetchurl {
    url = "https://github.com/supercollider/supercollider/releases/download/Version-${version}/SuperCollider-${version}-Source-linux.tar.bz2";
    sha256 = "0ynz1ydcpsd5h57h1n4a7avm6p1cif5a8rkmz4qpr46pr8z9p6iq";
  };

  hardeningDisable = [ "stackprotector" ];

  cmakeFlags = ''
    -DSC_WII=OFF
    -DSC_EL=OFF
    -DSC_QT:BOOL=OFF
    -DSUPERNOVA:BOOL=OFF
    -DSC_IDE:BOOL=OFF
    -DLIBSCSYNTH:BOOL=ON
    -DNO_X11:BOOL=TRUE
  '';

  nativeBuildInputs = with pkgs; [ cmake pkgconfig ];

  buildInputs = with pkgs; [alsaLib gcc libjack2 libsndfile fftw curl xorg.libXt readline systemd ];

  meta = {
    description = "Programming language for real time audio synthesis";
    homepage = http://supercollider.sourceforge.net/;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = [ "x686-linux" "x86_64-linux" ];
  };
}
