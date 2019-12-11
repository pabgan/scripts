from jira.client import JIRA

jira_server = "https://assia-inc.atlassian.net"
jira_user = None
jira_password = None

jira_server = {'server': jira_server}
jira = JIRA(options=jira_server, basic_auth=(jira_user, jira_password))

issue = jira.issue('DSLE-20701')
print(issue.fields.project.key)             # 'JRA'
print(issue.fields.issuetype.name)          # 'New Feature'
print(issue.fields.reporter.displayName)    # 'Mike Cannon-Brookes [Atlassian]'
