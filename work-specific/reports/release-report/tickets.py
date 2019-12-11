#!/usr/bin/python3
import sys, csv

f_tickets=sys.argv[1]
f_comments=sys.argv[2]

comments=None
# first we load the comments
with open(f_comments, mode='r') as infile:
    reader = csv.reader(infile)
    comments = {rows[0]:rows[1] for rows in reader}

with open(f_tickets) as tickets:
    print("%s,Comments" % (next(tickets).strip()))
    for ticket in tickets:
        ticket_id=ticket.split(',')[0]
        #print(ticket_id)
        if ticket_id in comments:
            print("%s,%s" % (ticket.strip(), comments[ticket_id].strip()))
        else:
            print("%s," % (ticket.strip()))
        
