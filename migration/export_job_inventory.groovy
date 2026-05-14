import jenkins.model.Jenkins
import hudson.model.Job
println("fullName,type,buildable")
Jenkins.instance.getAllItems(Job.class).sort { it.fullName }.each { job ->
  println("\"${job.fullName}\",\"${job.class.name}\",\"${job.isBuildable()}\"")
}
