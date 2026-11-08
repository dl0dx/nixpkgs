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
    owner = "MarcFontaine";
    repo = "pycsdr";
    rev = "8d70f51735a5dc661b7e1a067c3d7c14ca58c7a7";
    hash = "sha256-qJa2ObhzU4gEg9BXjSJU8xp/6flSPHLnITCck25k+cI=";
  };

  postPatch = ''
    substituteInPlace src/pycsdr.cpp \
      --replace-fail "PyModuleDef_HEAD_INIT," ".m_base = PyModuleDef_HEAD_INIT,"
  '';

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
