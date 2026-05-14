def repoUrl = 'https://github.com/your-org/cloudbees-ci-ps-full-automation-repo.git'

['devops-only','artifact-promotion','full-auto-deploy','casc-automation'].each { scenario ->
  pipelineJob("ps-onboarding/release/${scenario}") {
    definition {
      cpsScm {
        scm {
          git {
            remote { url(repoUrl) }
            branch('main')
          }
        }
        scriptPath("pipelines/Jenkinsfile.${scenario}")
      }
    }
  }
}
