#!/usr/bin/env python2
# coding: utf-8
import sys, re
import argparse
from helpers.db_reader import db_reader
from helpers.plain_text_writer import stdout_writer

def sanitize_query(query):
    query = re.sub("\s\s+", " ", query)
    query = query.strip()
    query = re.sub(";$", "", query)

    return query

if __name__ == "__main__":
    desc='''
Oh yeah
'''

    parser = argparse.ArgumentParser(description=desc)
    parser.add_argument("-u", "--username", help="username in Oracle, the name of the DB schema of the client", type=str, required=True)
    parser.add_argument("-p", "--password", help="Password for the username provided.", type=str, default='assia', required=False)
    parser.add_argument("-f", "--format", help="Format in which the output is desired. Currently supported: plain, jira, mkd, csv.", type=str, default='plain', required=False)
    parser.add_argument("-n", "--no-header", help="Switch to show or not column names. Default is true", action='store_false', dest='header')
    parser.add_argument("-s", "--separator", help="Specify which separator to use.", type=str, default=';')
    args = parser.parse_args(sys.argv[1:-1])
    query = sys.argv[-1]
    
    sc = db_reader(args.username, args.password)
    query = sanitize_query(query)
    result = sc.execute_sql(query)

    if result == 1:
        sys.exit(1)

    printer = stdout_writer()

    if args.format == "plain":
            printer.print_dictlist_as_table(result, args.header)
    elif args.format == "jira":
            printer.print_dictlist_as_jira_table(result)
    elif args.format == "mkd":
            printer.print_dictlist_as_mkd_table(result)
    elif args.format == "csv":
            printer.print_dictlist_as_csv_table(result, args.header, args.separator)
    else:
            print("Format %s not known." % (args.format))
