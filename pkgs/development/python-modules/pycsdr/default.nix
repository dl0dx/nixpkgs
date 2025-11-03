{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  csdr,
}:

buildPythonPackage rec {
  pname = "pycsdr";
  format = "setuptools";

  version = "0.18.36";
  src = fetchFromGitHub {
    owner = "luarvique";
    repo = "pycsdr";
    rev = "d14d4fdcae3f2eaddd3f0cf8539bf7660b36a704";
    hash = "sha256-8pfiBZJKPfOwNTRu0Kh+5bJpAZsNQQ8GVQzTSWF7W+Y=";
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
