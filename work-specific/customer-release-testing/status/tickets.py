#!/usr/bin/python3
import sys, csv

f_tickets=sys.argv[1]
f_comments=sys.argv[2]
csv_char=';'

comments=None
# first we load the comments
with open(f_comments, mode='r') as infile:
    reader = csv.reader(infile, delimiter=csv_char)
    comments = {rows[0]:rows[1] for rows in reader}

# then we go over each ticket, add the comment and print it
with open(f_tickets) as tickets:
    print("%s%sComments" % (next(tickets).strip(), csv_char))
    for ticket in tickets:
        ticket_id=ticket.split(csv_char)[0]
        #print(ticket_id)
        if ticket_id in comments:
            print("%s%s%s" % (ticket.strip(), csv_char, comments[ticket_id].strip()))
        else:
            print("%s%s" % (ticket.strip(), csv_char))
        
