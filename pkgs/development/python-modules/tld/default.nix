{
  lib,
  buildPythonPackage,
  factory-boy,
  faker,
  fetchPypi,
  pytestCheckHook,
  pytest-cov-stub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "tld";
  version = "0.13";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-k93l4cBL3xhEl26uRAcGN50h9KsjW3PAXXSD4HT7Vik=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  checkInputs = [
    factory-boy
    faker
  ];

  # These tests require network access, but disabledTestPaths doesn't work.
  # the file needs to be `import`ed by another Python test file, so it
  # can't simply be removed.
  preCheck = ''
    echo > src/tld/tests/test_commands.py
  '';

  pythonImportsCheck = [ "tld" ];

  meta = with lib; {
    description = "Extracts the top level domain (TLD) from the URL given";
    mainProgram = "update-tld-names";
    homepage = "https://github.com/barseghyanartur/tld";
    changelog = "https://github.com/barseghyanartur/tld/blob/${version}/CHANGELOG.rst";
    # https://github.com/barseghyanartur/tld/blob/master/README.rst#license
    # MPL-1.1 OR GPL-2.0-only OR LGPL-2.1-or-later
    license = with licenses; [
      lgpl21Plus
      mpl11
      gpl2Only
    ];
    maintainers = with maintainers; [ fab ];
  };
}
