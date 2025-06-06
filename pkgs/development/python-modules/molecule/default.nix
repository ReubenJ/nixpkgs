{
  lib,
  ansible-compat,
  ansible-core,
  buildPythonPackage,
  click-help-colors,
  enrich,
  fetchPypi,
  jsonschema,
  molecule,
  packaging,
  pluggy,
  pythonOlder,
  rich,
  setuptools,
  setuptools-scm,
  testers,
  wcmatch,
  withPlugins ? true,
  molecule-plugins,
  yamllint,
}:

buildPythonPackage rec {
  pname = "molecule";
  version = "25.3.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yHZpB8i4v+yI19Gl3xIyvUYGoMU9nLldOOhLRVppk6Y=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    ansible-compat
    ansible-core
    click-help-colors
    enrich
    jsonschema
    packaging
    pluggy
    rich
    yamllint
    wcmatch
  ] ++ lib.optional withPlugins molecule-plugins;

  pythonImportsCheck = [ "molecule" ];

  # tests can't be easily run without installing things from ansible-galaxy
  doCheck = false;

  passthru.tests.version =
    (testers.testVersion {
      package = molecule;
      command = "PY_COLORS=0 ${pname} --version";
    }).overrideAttrs
      (old: {
        # workaround the error: Permission denied: '/homeless-shelter'
        HOME = "$(mktemp -d)";
      });

  meta = with lib; {
    description = "Molecule aids in the development and testing of Ansible roles";
    homepage = "https://github.com/ansible-community/molecule";
    changelog = "https://github.com/ansible/molecule/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dawidd6 ];
    mainProgram = "molecule";
  };
}
