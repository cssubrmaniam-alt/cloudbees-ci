multibranchPipelineJob('ps-onboarding/platform/sample-multibranch') {
  branchSources {
    git {
      id('sample-multibranch-source')
      remote('https://github.com/your-org/sample-app.git')
    }
  }
}
