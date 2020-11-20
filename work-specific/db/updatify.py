#!/usr/bin/env python
# coding: utf-8
import re, sys

####################################
# Auxiliary functions
def parse_insert(line):
    line_parsed = re.findall('INSERT\s+INTO\s+(.+)\s*\((.+)\)\s*VALUES\s*\((.+)\)\s*;', line, re.IGNORECASE)
    result = {}
    
    if len(line_parsed) > 0:
        #print(line_parsed)
        result["TABLE"] = line_parsed[0][0].strip()
        keys = line_parsed[0][1].split(",")
        values = [value for value in line_parsed[0][2].split(",")]
        for (key, value) in zip(keys, values):
            result[key.strip().upper()] = value.strip()

    return result

####################################
# 0. Handle call
# We go through the provisioning file
if len(sys.argv) < 2:
    fprovname = raw_input("Enter provisioning file name: ")
else:
    fprovname = sys.argv[1]
fprov = open(fprovname)

####################################
# 1. Now we parse every line in the provisioning file
for line in fprov:
    values = parse_insert(line)
    
    # If it happens to be a INSERT statement into table PORT_INFO we updatify it and write it to output file
    if len(values) > 0 and values.get("TABLE") == "PORT_INFO":
        update_sentence = "UPDATE PORT_INFO SET " 

        first = True
        for k,v in values.items():
            if k in ('TABLE','ELEMENT_ID','LINE_ID'):
                continue

            if first:
                update_sentence = update_sentence + k + '=' + v
                first = False
            else:
                update_sentence = update_sentence + ', ' + k + '=' + v
        
        update_sentence = update_sentence + ' WHERE LINE_ID=' + values.get('LINE_ID') + ';'

        print(update_sentence)
