{ stdenv, lib, fetchFromGitHub
, cmake, pkg-config, fftwFloat, libsamplerate
}:

stdenv.mkDerivation rec {
  pname = "csdr-lu";
  version = "0.18.23-lu";

  src = fetchFromGitHub {
    owner = "luarvique";
    repo = "csdr";
    rev = "a7d53ebe1fd94fb06d9ddfd00569d3df45d8f64f";
    hash = "sha256-Q7g1OqfpAP6u78zyHjLP2ASGYKNKCAVv8cgGwytZ+cE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  propagatedBuildInputs = [
    fftwFloat
    libsamplerate
  ];

  hardeningDisable = lib.optional stdenv.isAarch64 "format";

  postFixup = ''
    substituteInPlace "$out"/lib/pkgconfig/csdr.pc \
      --replace '=''${prefix}//' '=/' \
      --replace '=''${exec_prefix}//' '=/'
  '';
    
  meta = with lib; {
    homepage = "https://github.com/jketterl/csdr";
    description = "A simple DSP library and command-line tool for Software Defined Radio";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
    maintainers = teams.c3d2.members;
  };
}
