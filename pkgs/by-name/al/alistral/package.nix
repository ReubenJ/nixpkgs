{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "alistral";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "RustyNova016";
    repo = "Alistral";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6p2KMFTdC04lEhNQiu88ALBPrpQUF9JhXDacntoq4lE=";
  };

  # remove if updating to rust 1.85
  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail "[package]" ''$'cargo-features = ["edition2024"]\n[package]'\
      --replace-fail 'rust-version = "1.85.0"' ""
  '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-2pi2hfQTLs2HAlgp1DQCMFp/nMJQfcuQFhGlrsWgy5E=";

  env.RUSTC_BOOTSTRAP = 1;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  # Wants to create config file where it s not allowed
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://rustynova016.github.io/Alistral/";
    changelog = "https://github.com/RustyNova016/Alistral/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Power tools for Listenbrainz";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jopejoe1 ];
    mainProgram = "alistral";
  };
})
