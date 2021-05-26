#!/usr/bin/python3
import argparse, os
from jira import JIRA
#from client import JIRA

########################################################
### CONFIGURATION
########################################################
customfields = dict()
customfields_file_path = os.path.join(os.getenv("HOME"), '.config/jira-turbo/customfields.csv')
with open(customfields_file_path) as customfields_file:
    for row in customfields_file:
        pretty_name, custom_name = row.split(',')
        # We want to be able to translate in both directions
        customfields[pretty_name.strip()] = custom_name.strip()
        customfields[custom_name.strip()] = pretty_name.strip()

def issue_print(issue, print_name=True):
    field_names = dir(issue.fields)
    for field in field_names:
        # Skip private attributes
        if '__' not in field:
            # Print the pretty name if available in customfields.csv or the one that comes from
            # JIRA in other case
            if print_name:
                print('{}={}'.format(customfields.get(field, field), getattr(issue.fields, field)))
            else:
                print('{}'.format(getattr(issue.fields, field)))


########################################################
### ACTIONS
########################################################
def query():
    if args.issue:
        if 'all' in args.fields_requested:
            issue_print(jira.issue(args.issue))
        else:
            # Translate the field name requested by the user if available in customfields.csv or 
            # else request it as is
            fields_names = [ customfields.get(field_requested, field_requested)  for field_requested in args.fields_requested ]
            issue_print(jira.issue(args.issue, fields=fields_names), False)
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

    args.fields_requested = 'all'
    if args.fields is not None:
        args.fields_requested = args.fields.split(',')

    jira = JIRA('https://assia-inc.atlassian.net/')
    actions[args.action]()
