{ lib, buildPythonPackage, fetchFromGitHub, csdr-lu }:

buildPythonPackage rec {
  pname = "pycsdr";

  version = "0.18.24-lu";
  src = fetchFromGitHub {
    owner = "luarvique";
    repo = "pycsdr";
    rev = "33af89d2cdf2784346892d61f6a4f3b03ba7148a";
    hash = "sha256-58IQfQwQP2iZ7W51MKAXjMJ3mGF2xWevsczeKgJ7+c4=";
  };

  propagatedBuildInputs = [ csdr-lu ];

  # has no tests
  doCheck = false;
  pythonImportsCheck = [ "pycsdr" ];

  meta = {
    homepage = "https://github.com/jketterl/pycsdr";
    description = "bindings for the csdr library";
    license = lib.licenses.gpl3Only;
    maintainers = lib.teams.c3d2.members;
  };
}
