{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  csdr,
}:

buildPythonPackage rec {
  pname = "pycsdr";
  format = "setuptools";

  version = "0.18.29";
  src = fetchFromGitHub {
    owner = "luarvique";
    repo = "pycsdr";
    rev = "7cfc6089305b054a5c0c8db404d3cb3ebbcb4513";
    hash = "sha256-I43hmOZagzqXE45gUszi/nAWHL/cp2kE//knNIXJnyU=";
  };

  propagatedBuildInputs = [ csdr ];

  # has no tests
  doCheck = false;
  pythonImportsCheck = [ "pycsdr" ];

  meta = with lib; {
    homepage = "https://github.com/luarvique/pycsdr";
    description = "bindings for the csdr library";
    license = licenses.gpl3Only;
    maintainers = teams.c3d2.members ++ [ maintainers.mafo ];
  };
}
