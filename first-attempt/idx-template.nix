{ pkgs, apikey, giturl ? "missingurl", subdir ? "", launchactivity ? "",... }: {
  packages = [
      pkgs.git
      pkgs.sdkmanager
      pkgs.j2cli
  ];
  bootstrap = ''
    mkdir -p "$WS_NAME" tmp
    
    git clone --depth 1 ${giturl} tmp

    mv tmp/${subdir}/* "$WS_NAME"

    # Find every local.defaults.properties file in the repo ane replace the MAPS_API_KEY property with said value
    # find $WS_NAME -type f -name 'local.defaults.properties' -exec sed -i "s/\(MAPS_API_KEY=\).*/\1\"DEFAULT_API_KEY\"/" {} \;

    # Create a secrets.properties file in the repo ane replace the MAPS_API_KEY property with said value
    touch secrets.properties
    echo "MAPS_API_KEY='${apikey}\'" > secrets.properties

    chmod -R +w "$WS_NAME"
    mkdir -p "$WS_NAME/.idx/"

    # We create a dev.nix that builds the subproject specified at template instantiation
    launch_activity=${launchactivity} j2 --format=env ${./devNix.j2} -o $WS_NAME/.idx/dev.nix

    mv "$WS_NAME" "$out"
  '';
}
