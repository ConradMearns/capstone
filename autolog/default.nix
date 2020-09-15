with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "env";
  env = buildEnv { name = name; paths = buildInputs; };
  buildInputs = [
    python3
    jupyter
    python3Packages.pip
    python3Packages.spacy
    python3Packages.spacy_models.en_core_web_sm
    python3Packages.numpy
    python3Packages.pdfminer
    python3Packages.beautifulsoup4
    python3Packages.urllib3
    python3Packages.requests
    python3Packages.pyopenssl

  ];
}
