#!/usr/bin/python3
import argparse
from jira import JIRA

jira = JIRA('https://assia-inc.atlassian.net/')


if __name__ == "__main__":
    desc= "Interact with Jira instance"
    desc+="Following ASSIA-QA-land structure, it only takes one parameter by command line (the path to the config.properties file) where all the others setting should be there.\n"
    parser = argparse.ArgumentParser(description=desc)
    parser.add_argument("action", help="hello")
    parser.add_argument("--issue", required=False)
    parser.add_argument("--summary", action='store_true', required=False)
    args = parser.parse_args()

    if args.action == 'query':
        if args.summary:
            issue=jira.issue(args.issue)
            print(issue.fields.summary)
        else:
            print('Querying')

