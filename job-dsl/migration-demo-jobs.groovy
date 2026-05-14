pipelineJob('ps-onboarding/migration/oss-to-modern-validation') {
  definition {
    cps {
      script("""
pipeline {
  agent any
  stages {
    stage('Validate Migration') {
      steps { echo 'Validate migrated OSS Jenkins job on CloudBees CI Modern' }
    }
  }
}
""")
    }
  }
}
