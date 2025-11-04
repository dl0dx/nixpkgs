{
  stdenv,
  lib,
  python3Packages,
  fetchFromGitHub,
  pkg-config,
  cmake,
  libsamplerate,
  fftwFloat,
  rtl-sdr,
  soapysdr-with-plugins,
  csdr,
  csdreti,
  direwolf,
  aprs-symbols,
  sox,
  wsjtx,
  codecserver,
  versionCheckHook,
}:

let

  js8py = python3Packages.buildPythonPackage rec {
    pname = "js8py";
    version = "0.1.1";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "jketterl";
      repo = pname;
      rev = version;
      sha256 = "1j80zclg1cl5clqd00qqa16prz7cyc32bvxqz2mh540cirygq24w";
    };

    pythonImportsCheck = [
      "js8py"
      "test"
    ];

    meta = with lib; {
      homepage = "https://github.com/jketterl/js8py";
      description = "Library to decode the output of the js8 binary of JS8Call";
      license = licenses.gpl3Only;
      teams = [ teams.c3d2 ];
    };
  };

  owrx_connector = stdenv.mkDerivation rec {
    pname = "owrx_connector";
    version = "0.6.5";

    src = fetchFromGitHub {
      owner = "luarvique";
      repo = pname;
      rev = "870285269143048f850151346980942a12ccf24b";
      sha256 = "sha256-e0VEv9t4gVDxJEbDJm1aKSJeqlmhT/QimC3x4JJ6ke8=";
    };

    postPatch = ''
      substituteInPlace CMakeLists.txt --replace-fail \
        "cmake_minimum_required (VERSION 3.0)" \
        "cmake_minimum_required (VERSION 3.10)"
    '';

    nativeBuildInputs = [
      cmake
      pkg-config
    ];

    cmakeFlags = [ "-DCMAKE_POLICY_VERSION_MINIMUM=3.5" ];

    buildInputs = [
      libsamplerate
      fftwFloat
      csdr
      rtl-sdr
      soapysdr-with-plugins
    ];

    nativeInstallCheckInputs = [ versionCheckHook ];
    versionCheckProgram = "${placeholder "out"}/bin/rtl_connector";
    doInstallCheck = true;

    meta = with lib; {
      homepage = "https://github.com/luarvique/owrx_connector";
      description = "Set of connectors that are used by OpenWebRX to interface with SDR hardware";
      license = licenses.gpl3Only;
      platforms = platforms.unix;
      teams = [ teams.c3d2 ];
    };
  };

in
python3Packages.buildPythonApplication rec {
  pname = "openwebrx";
  version = "1.2.96";
  format = "setuptools";
  src = fetchFromGitHub {
    owner = "luarvique";
    repo = "openwebrx";
    rev = "0db5c412784066cd1a280d824a76641a9ba948ea";
    hash = "sha256-fOeB7xR2ZM2wB4DylifrZJdh0otYRB0F4HwvgTImo+c=";
  };

  dependencies =
    with python3Packages;
    [
      setuptools
      csdr
      pycsdr
      pycsdreti
      pydigiham
#      paho-mqtt
    ]
    ++ [
      js8py
      soapysdr-with-plugins
      owrx_connector
      direwolf
      sox
      wsjtx
      codecserver
    ];

  prePatch = ''
    substituteInPlace owrx/feature.py \
        --replace "/usr/share/aprs-symbols" "${aprs-symbols}/share/aprs-symbols" \
    '';
  
  pythonImportsCheck = [
    "csdr"
    "owrx"
#    "paho"
    "test"    
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    inherit js8py owrx_connector;
  };

  meta = with lib; {
    homepage = "https://github.com/luarvique/openwebrx";
    description = "Simple DSP library and command-line tool for Software Defined Radio";
    mainProgram = "openwebrx";
    license = licenses.gpl3Only;
    teams = [ teams.c3d2 ];
  };
}
