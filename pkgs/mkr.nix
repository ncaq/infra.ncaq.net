{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "mkr";
  version = "0.63.0";
  src = fetchFromGitHub {
    owner = "mackerelio";
    repo = "mkr";
    rev = "v${version}";
    hash = "sha256-hL+w1APTlppRAZ7L7VEeNTreKowQqcj2xYJjaNa0QkM=";
  };
  vendorHash = "sha256-J5C81e2Gh9tnp+yY4xZfGQn+IXhohHiXZbcYJdcogxI=";
  # TestGetGithubToken fails in sandbox environment
  doCheck = false;
  meta = {
    description = "Command Line Tool for Mackerel";
    homepage = "https://github.com/mackerelio/mkr";
    license = lib.licenses.asl20;
    mainProgram = "mkr";
  };
}
