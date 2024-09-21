{ lib
, stdenv
, fetchFromGitHub
, perl
, swig
, gd
, ncurses
, python311
, libxml2
, tcl
, libusb-compat-0_1
, pkg-config
, boost
, libtool
, perlPackages
, pythonBindings ? true
, tclBindings ? true
, perlBindings ? true
, autoconf
, automake
}:
let
  python3 = python311; # needs distutils and imp
in
stdenv.mkDerivation rec {
  pname = "hamlib";
  version = "4.5.5";

  src = fetchFromGitHub {
    owner = "MarcFontaine";
    repo = "Hamlib";
    rev = "4efdf1dffdf2053f509eba8138d1f9cdfa4900d0";
    hash = "sha256-BLMztoq79lQ2zy+mJ2BBUDfxsCIDSnCPq9bvweLd8oQ=";
  };

  nativeBuildInputs = [
    swig
    pkg-config
    libtool
    autoconf
    automake
  ];

  buildInputs = [
    gd
    libxml2
    libusb-compat-0_1
    boost
  ] ++ lib.optionals pythonBindings [ python3 ncurses ]
    ++ lib.optionals tclBindings [ tcl ]
    ++ lib.optionals perlBindings [ perl perlPackages.ExtUtilsMakeMaker ];

  preConfigure = ''
    ./bootstrap
  '';

  configureFlags = lib.optionals perlBindings [ "--with-perl-binding" ]
    ++ lib.optionals tclBindings [ "--with-tcl-binding" "--with-tcl=${tcl}/lib/" ]
    ++ lib.optionals pythonBindings [ "--with-python-binding" ];

  meta = with lib; {
    description = "Runtime library to control radio transceivers and receivers";
    longDescription = ''
    Hamlib provides a standardized programming interface that applications
    can use to send the appropriate commands to a radio.

    Also included in the package is a simple radio control program 'rigctl',
    which lets one control a radio transceiver or receiver, either from
    command line interface or in a text-oriented interactive interface.
    '';
    license = with licenses; [ gpl2Plus lgpl2Plus ];
    homepage = "https://hamlib.sourceforge.net";
    maintainers = with maintainers; [ relrod ];
    platforms = with platforms; unix;
  };
}
