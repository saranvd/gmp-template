{ pkgs, apikey ? "missingkey", giturl ? "missingurl",... }: {
      packages = [
			pkgs.git
      pkgs.sdkmanager
    ];
  bootstrap = ''
    mkdir -p "$WS_NAME"
    mkdir -p "$WS_NAME/repo/"
    git clone --depth 1 ${giturl} repo
    cp -r repo "$WS_NAME/repo"
    echo ${apikey} > "$WS_NAME/apikey.txt"
    chmod -R +w "$WS_NAME"
    mkdir -p "$WS_NAME/.idx/"
    cp -rf ${./dev.nix} "$WS_NAME/.idx/dev.nix"
    mv "$WS_NAME" "$out"
  '';
}