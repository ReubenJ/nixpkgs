{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "conftest";
  version = "0.59.0";

  src = fetchFromGitHub {
    owner = "open-policy-agent";
    repo = "conftest";
    tag = "v${version}";
    hash = "sha256-bmZp1cPNTm6m30YxjlWdnfv2437nDXH+taDNFZ0OKIY=";
  };
  vendorHash = "sha256-aPvGbtAucb9OdcydO4dMLJrrM3XretPI7zyJULlm1fg=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/open-policy-agent/conftest/internal/commands.version=${version}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

  postInstall = ''
    installShellCompletion --cmd conftest \
      --bash <($out/bin/conftest completion bash) \
      --fish <($out/bin/conftest completion fish) \
      --zsh <($out/bin/conftest completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    export HOME="$(mktemp -d)"
    $out/bin/conftest --version | grep ${version} > /dev/null
  '';

  meta = with lib; {
    description = "Write tests against structured configuration data";
    mainProgram = "conftest";
    downloadPage = "https://github.com/open-policy-agent/conftest";
    homepage = "https://www.conftest.dev";
    changelog = "https://github.com/open-policy-agent/conftest/releases/tag/v${version}";
    license = licenses.asl20;
    longDescription = ''
      Conftest helps you write tests against structured configuration data.
      Using Conftest you can write tests for your Kubernetes configuration,
      Tekton pipeline definitions, Terraform code, Serverless configs or any
      other config files.

      Conftest uses the Rego language from Open Policy Agent for writing the
      assertions. You can read more about Rego in 'How do I write policies' in
      the Open Policy Agent documentation.
    '';
    maintainers = with maintainers; [
      jk
      yurrriq
    ];
  };
}
