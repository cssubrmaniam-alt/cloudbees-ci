folder('ps-onboarding') {
  displayName('PS Onboarding')
  description('CloudBees PS onboarding automation generated jobs')
}
['team-a','team-b','platform','release','migration'].each { team ->
  folder("ps-onboarding/${team}") {
    displayName(team)
    description("Generated folder for ${team}")
  }
}
