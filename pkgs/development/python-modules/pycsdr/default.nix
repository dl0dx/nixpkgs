{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  csdr,
}:

buildPythonPackage rec {
  pname = "pycsdr";
  format = "setuptools";

  version = "0.18.43";
  src = fetchFromGitHub {
    owner = "luarvique";
    repo = "pycsdr";
    rev = "e0029bdfb135ff09557dc296ef9772b17ff4fe1a";
    hash = "sha256-Qd0QNfrbmhxKC3mvzAmMFtKmE+tUdwumcXKEfD6ZYhA=";
  };

  buildInputs = [ csdr ];
  # has no tests
  doCheck = false;
  pythonImportsCheck = [ "pycsdr" ];

  meta = {
    homepage = "https://github.com/luarvique/pycsdr";
    description = "Bindings for the csdr library";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.mafo ];
  };
}
