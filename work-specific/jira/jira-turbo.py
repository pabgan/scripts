#!/usr/bin/python3
from jira import JIRA

jira = JIRA('https://assia-inc.atlassian.net/')

issue=jira.issue('DSLE-21230')
print(issue.fields.summary)
