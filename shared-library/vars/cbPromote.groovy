def call(Map args = [:]) {
  def fromEnv = args.get('from', 'build')
  def toEnv = args.get('to', 'dev')
  def version = args.get('version', '0.0.0')
  echo "Promoting artifact ${version} from ${fromEnv} to ${toEnv}"
  sh """
    mkdir -p evidence/06-phase-6-scenarios/cli-output
    echo "promotion version=${version} from=${fromEnv} to=${toEnv} build=${BUILD_NUMBER}" | tee -a evidence/06-phase-6-scenarios/cli-output/artifact-promotion.txt
  """
}
