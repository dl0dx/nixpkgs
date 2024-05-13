{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, soapysdr, sdrplay }:

stdenv.mkDerivation rec {
  pname = "soapysdr-sdrplay3";
  version = "0.8.8";

  src = fetchFromGitHub {
    owner = "luarvique";
    repo = "SoapySDRPlay3";
    rev = version;
    sha256 = "sha256-EViBNaWHLM0QZyY1bJl/g/ZTO0ZmC1WZuK+8LocjDkQ=";
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
