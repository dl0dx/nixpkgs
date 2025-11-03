{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  fftwFloat,
  libsamplerate,
  versionCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "csdr";
  version = "0.18.36";

  src = fetchFromGitHub {
    owner = "luarvique";
    repo = "csdr";
    rev = "70c93d6a9f8befae513912d98d2c203bb6f93195";
    hash = "sha256-Ih75Y8At4Tx9fTHasHQktnhjYY2708DWdxn/V+8UKT8=";
  };

  postPatch = ''
    # function is not defined in any headers but used in libcsdr.c
    echo "int errhead();" >> src/predefined.h

    substituteInPlace CMakeLists.txt --replace-fail \
      "cmake_minimum_required (VERSION 3.0)" \
      "cmake_minimum_required (VERSION 3.10)"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [ "-DCMAKE_POLICY_VERSION_MINIMUM=3.5" ];

  propagatedBuildInputs = [
    fftwFloat
    libsamplerate
  ];

  hardeningDisable = lib.optional stdenv.hostPlatform.isAarch64 "format";

  postFixup = ''
    substituteInPlace "$out"/lib/pkgconfig/csdr.pc \
      --replace '=''${prefix}//' '=/' \
      --replace '=''${exec_prefix}//' '=/'
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  meta = with lib; {
    homepage = "https://github.com/luarvique/csdr";
    description = "Simple DSP library and command-line tool for Software Defined Radio";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
    teams = [ teams.c3d2 ];
  };
}
