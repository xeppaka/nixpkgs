{ stdenv, fetchurl, patchelf, glibc, makeWrapper, autoPatchelfHook, glib, openssl,
libX11, libxcb, libXi, libSM, libICE, libXrender, fontconfig, freetype, libglvnd }:

let
  version = "1807";
  srcs = {
    x86_64-linux = fetchurl {
      url = "http://releases.sailfishos.org/sdk/installers/${version}/SailfishOSSDK-Beta-${version}-Qt5-linux-64-offline.run";
      sha256 = "366eb9a1e63ce318fecbf06b15dcaecd0ffa90506164655882b571831dcd08c6";
    };
  };

in stdenv.mkDerivation {
  name = "sailfishos-sdk";

  src = srcs.${stdenv.hostPlatform.system};
  buildInputs = [ glib libxcb libX11 libXi libSM libICE libXrender fontconfig freetype libglvnd ];
  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];
  runtimeDependencies = openssl.out;
  dontPatchELF = true;
  dontStrip = true;

  unpackPhase = ''
    echo 'unpack not required...'
  '';

  installPhase = let
    executableName = "SailfishOSSDK-Beta-${version}-Qt5-linux-64-offline.run";
  in ''
    mkdir -p $out/bin
    cp $src $out/bin/${executableName}
    chmod +x $out/bin/${executableName}
    makeWrapper $out/bin/${executableName} $out/bin/sailfish-sdk.sh
  '';
}

