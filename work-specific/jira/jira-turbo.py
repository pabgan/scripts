#!/usr/bin/python3
import argparse
from jira import JIRA
#from client import JIRA

########################################################
### CONFIGURATION
########################################################

########################################################
### ACTIONS
########################################################
def query():
    if args.issue:
        if args.fields == 'all':
            issue = jira.issue(args.issue)

            fields_names = dir(issue.fields)
            for field in fields_names:
                if '__' not in field:
                    print(field)
                    print('----------')
                    print(getattr(issue.fields, field))
                    print('\n')
#            for field in issue.fields.items():
#                print(getattr(issue.fields, field))
        else:
            issue = jira.issue(args.issue, fields=args.fields)

            for field in args.fields.split(','):
                print(getattr(issue.fields, field))
    elif args.issues:
        result = jira.search_issues(args.issues)
        print('KEY;SUMMARY;UPDATED;ASSIGNEE;STATUS')
        for issue in result:
            print('{};{};{};{};{}'.format(issue.key, issue.fields.summary, issue.fields.updated, issue.fields.assignee, issue.fields.status))
    else:
        print('%s option not implemented yet' %(args))

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

    jira.assign_issue(args.issue, account_id=args.value)

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
    parser.add_argument("--issues", required=False)
    parser.add_argument("--fields", required=False)
    parser.add_argument("--value", required=False)
    args = parser.parse_args()


    jira = JIRA('https://assia-inc.atlassian.net/')
    actions[args.action]()
