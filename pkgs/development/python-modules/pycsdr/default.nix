{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  csdr,
}:

buildPythonPackage rec {
  pname = "pycsdr";
  format = "setuptools";

  version = "0.18.37";
  src = fetchFromGitHub {
    owner = "luarvique";
    repo = "pycsdr";
    rev = "db2050bd02ddd1d630cee8d27aaa4432767717ca";
    hash = "sha256-TB8UaT/z8qjaQ9N6s2MmWA5YvM533YyRpnweqLxy+QM=";
  };

  propagatedBuildInputs = [
    csdr
  ];

  # has no tests
  doCheck = false;
  pythonImportsCheck = [ "pycsdr" ];

  meta = {
    homepage = "https://github.com/luarvique/pycsdr";
    description = "Bindings for the csdr library";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.c3d2 ];
  };
}
