import jenkins.model.Jenkins
Jenkins.instance.pluginManager.plugins.sort { it.shortName }.each { p ->
  println("${p.shortName},${p.version},${p.isEnabled()}")
}
