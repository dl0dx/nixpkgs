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

stdenv.mkDerivation (finalAttrs: {
  pname = "csdr";
  version = "0.18.37";

  src = fetchFromGitHub {
    owner = "luarvique";
    repo = "csdr";
    rev = finalAttrs.version;
    sha256 = "sha256-3l9eAreapB9MVMZC5jxtjBD08i1hh+I0ypWqzLoOluo=";
  };

  postPatch = ''
    # function is not defined in any headers but used in libcsdr.c
    echo "int errhead();" >> src/predefined.h
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

#  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  meta = with lib; {
    homepage = "https://github.com/luarvique/csdr";
    description = "Simple DSP library and command-line tool for Software Defined Radio";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
    meta.mainProgram = "csdr";
    teams = [ teams.c3d2 ];
  };
})
