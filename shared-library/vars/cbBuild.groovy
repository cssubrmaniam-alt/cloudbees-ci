def call(Map args = [:]) {
  def appName = args.get('appName', 'sample-app')
  echo "Building ${appName}"
  sh """
    mkdir -p build evidence/06-phase-6-scenarios/cli-output
    echo "build=success app=${appName} build=${env.BUILD_NUMBER}" | tee build/build-result.txt
    cp build/build-result.txt evidence/06-phase-6-scenarios/cli-output/
  """
}
