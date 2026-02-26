{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:
buildNpmPackage rec {
  pname = "mackerel-mcp-server";
  version = "0.4.0";
  src = fetchFromGitHub {
    owner = "mackerelio-labs";
    repo = "mcp-server";
    rev = "v${version}";
    hash = "sha256-YQ78/k0ScOYLbGfqGki87HokINMjIbfZTlL5i/ZBd2c=";
  };
  npmDepsHash = "sha256-4Je1lF4piOy2T4U4pGo10his1ky2PVCTcypfCdRj3g4=";
  meta = {
    description = "A Model Context Protocol server for interacting with Mackerel";
    homepage = "https://github.com/mackerelio-labs/mcp-server";
    license = lib.licenses.asl20;
    mainProgram = "mcp-server";
  };
}
