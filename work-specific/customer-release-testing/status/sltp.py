#!/usr/bin/python3
import sys, re

f_sltp_toc = sys.argv[1]

def print_table_header():
    print('| ID | Title | Status |')
    print('| -- | ----- | ------ |')

#print('###############################\n')
with open(f_sltp_toc, mode='r') as infile:
    for line in infile:
#        print('-------------------------------\n')
        line = line.strip()
#        print('Parsing \'' + line + '\'')
        if not line:
#            print('Empty line!!')
            continue

        # Generic / Customer specific division
        if re.search('^[0-9]\s', line):
            x = re.findall('^([0-9])\s+(.*)', line)
            print("### %s" % (x[0][1]))
            print_table_header()
        # Actual list of tests
        if re.search('^[0-9]\.', line):
            title = re.findall('^([0-9])\.([0-9]+)\s+(.*)', line)
            status = re.findall('^Status:\s*(.*)', infile.readline())
            if status:
                print("| %s.%s | %s | %s |" % (title[0][0], title[0][1], title[0][2], status[0]))

#print('bam!')
