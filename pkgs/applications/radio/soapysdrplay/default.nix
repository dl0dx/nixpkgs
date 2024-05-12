{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, soapysdr, sdrplay }:

stdenv.mkDerivation rec {
  pname = "soapysdr-sdrplay3";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "luarvique";
    repo = "SoapySDRPlay3";
    rev = "367111abbea065f999b613becda87cb0699a3e8d";
    sha256 = "sha256-jkDIB3U3oxD5CkkPii/dOm5xIlamBfO1WDTp23rXChk=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ soapysdr sdrplay ];

  cmakeFlags = [
    "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/"
  ];

  meta = with lib; {
    description = "Soapy SDR module for SDRplay";
    homepage = "https://github.com/pothosware/SoapySDRPlay3";
    license = licenses.mit;
    maintainers = [ maintainers.pmenke ];
    platforms = platforms.linux;
  };
}
