{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "juliaup";
  version = "v1.17.13";

  src = fetchFromGitHub {
    owner = "JuliaLang";
    repo = pname;
    rev = version;
    hash = "sha256-a1TNWvkEV5mb7Tuy8OqPrQoPwuhrjAzn2wP1vD+IhJo=";
  };

  cargoHash = "sha256-Pej/SiyPb54Om3PRfL7US8d0wJf6GMwO3PjtL/oPV0U=";

  checkFlags = [
    # fail due to the filesystem being read-only
    "--skip=command_gc" 
    "--skip=command_remove"
  ];

  meta = with lib; {
    description = "Julia installer and version multiplexer";
    homepage = "https://github.com/JuliaLang/juliaup";
    license = licenses.mit;
    maintainers = [ maintainers.reubenj ];
  };
}