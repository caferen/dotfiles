{ lib, stdenv, fetchurl, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "juno";
  version = "0.0.2";

  srcs = [
    (fetchurl {
      url = "https://github.com/gvolpe/Juno/releases/download/${version}/Juno-ocean.tar.xz";
      sha256 = "I+jfI5N9QRLcP2xNvEgzd/B+bBeruj1hXYj69buR/yM=";
    })
  ];

  sourceRoot = ".";

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    cp -a Juno* $out/share/themes
    rm $out/share/themes/*/{LICENSE,README.md}
    runHook postInstall
  '';

  meta = with lib; {
    description = "GTK themes inspired by epic vscode themes";
    homepage = "https://github.com/EliverLara/Juno";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = [ maintainers.gvolpe ];
  };
}
