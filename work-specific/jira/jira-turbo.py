#!/usr/bin/python3
import argparse
from jira import JIRA

########################################################
### CONFIGURATION
########################################################

########################################################
### ACTIONS
########################################################
def query():
    if args.issue:
        issue = jira.issue(args.issue)

        print(getattr(issue.fields, args.field))
    else:
        print('Only --issue querying implemented yet')

def edit():
    if args.issue is None:
        print('ERROR: --issue needed')
        return

    if args.field is None:
        print('ERROR: --field needed')
        return

    if args.value is None:
        print('ERROR: --value needed')
        return

    issue = jira.issue(args.issue)
    fields={args.field: args.value}
    issue.update(fields)

def assign():
    if args.issue is None:
        print('ERROR: --issue needed')
        return

    jira.assign_issue(args.issue, args.value)

########################################################
### MAIN
########################################################
actions = {'query' : query,
           'edit' :  edit,
           'assign' :  assign,
}

if __name__ == "__main__":
    desc= "Interact with Jira"
    parser = argparse.ArgumentParser(description=desc)
    parser.add_argument("action", help="One of {}".format(', '.join(actions.keys())))
    parser.add_argument("--issue", required=False)
    parser.add_argument("--field", required=False)
    parser.add_argument("--value", required=False)
    args = parser.parse_args()


    jira = JIRA('https://assia-inc.atlassian.net/')
    actions[args.action]()
