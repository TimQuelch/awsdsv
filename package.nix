{
  lib,
  stdenv,
  makeBinaryWrapper,
  bash,
  jq,
  yq,
}:
stdenv.mkDerivation {
  pname = "awsdsv";
  version = "unstable";

  src = ./.;

  # TODO handle dsv dependency
  buildInputs = [
    bash
    jq
    yq
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  installPhase =
    let
      binPath = lib.makeBinPath [
        jq
        yq
      ];
    in
    ''
      mkdir -p $out/{bin,share/awsdsv}

      cp awsdsv $out/bin/
      cp config.yaml $out/share/awsdsv/

      wrapProgram $out/bin/awsdsv \
        --set AWSDSV_CONFIG_FILE "$out/share/awsdsv/config.yaml" \
        --prefix PATH : ${binPath}
    '';
}
