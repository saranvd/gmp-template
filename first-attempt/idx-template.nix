{ pkgs, apikey ? "missingkey", giturl ? "missingurl",... }: {
      packages = [
			pkgs.git
    ];
  bootstrap = ''
    mkdir -p "$WS_NAME"
    git clone ${giturl}
    echo ${apikey} > "$WS_NAME/apikey.txt"
    chmod -R +w "$WS_NAME"
    mv "$WS_NAME" "$out"
  '';
}