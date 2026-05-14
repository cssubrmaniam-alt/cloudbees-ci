def call(Map args = [:]) {
  def envName = args.get('environment', 'dev')
  def appName = args.get('appName', 'sample-app')
  echo "Deploying ${appName} to ${envName}"
  sh """
    mkdir -p evidence/06-phase-6-scenarios/cli-output
    echo "deploy=success app=${appName} environment=${envName} build=${BUILD_NUMBER}" | tee evidence/06-phase-6-scenarios/cli-output/deploy-${envName}.txt
  """
}
