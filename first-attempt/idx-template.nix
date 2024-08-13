{ pkgs, apikey ? "", giturl ? "missingurl", subdir ? "", launchactivity ? "",... }: {
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
    find $WS_NAME -type f -name 'local.defaults.properties' -exec sed -i "s/\(MAPS_API_KEY=\).*/\1\"${apikey}\"/" {} \;

    # The maps samples seem to have really outdated versions of gradle. We simple search for all gradle properties files and upgrade the gradle distribution
    find $WS_NAME -type f -name 'gradle-wrapper.properties' -exec sed -i 's|distributionUrl=.*|distributionUrl=https\\://services.gradle.org/distributions/gradle-8.7-bin.zip|' {} \;

    chmod -R +w "$WS_NAME"
    mkdir -p "$WS_NAME/.idx/"

    # We create a dev.nix that builds the subproject specified at template instantiation
    launch_activity=${launchactivity} j2 --format=env ${./devNix.j2} -o $WS_NAME/.idx/dev.nix

    mv "$WS_NAME" "$out"
  '';
}
