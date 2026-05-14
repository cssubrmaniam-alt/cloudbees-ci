import com.cloudbees.plugins.credentials.CredentialsProvider
import com.cloudbees.plugins.credentials.Credentials
import jenkins.model.Jenkins
def creds = CredentialsProvider.lookupCredentials(Credentials.class, Jenkins.instance, null, null)
creds.each { c ->
  def id = c.hasProperty('id') ? c.id : 'NO_ID_PROPERTY'
  println("${id},${c.class.name}")
}
