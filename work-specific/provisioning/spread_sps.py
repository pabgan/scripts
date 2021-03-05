#!/usr/bin/env python2
# coding: utf-8
import sys, logging, argparse
from helpers.sql_reader import parse_insert

def print_prov(prov):
    current_prov = dict()
    
    for line in prov:
        sp = line["SERVICE_PRODUCT"] 
        current_prov[sp] = current_prov.get(sp, 0) + 1
    
    print(current_prov)

#################################################
# MAIN
#
if __name__ == "__main__":

    #################################################
    # 0. Parse arguments
    #
    desc = "Modify SQL provisioning file to evenly assign SPs provided in a file among lines, all this done per DSLAM, since every one has its own limitations.\n"
    desc += "Usage: spread_sps.py [OPTIONS] DSLAM_NAME \n"
    parser = argparse.ArgumentParser(description=desc)
    parser.add_argument('wanted_service_products_file')
    parser.add_argument("--debug", help="Wether print debug statements. False by default", action='store_true')

#    if args.debug:
#        logging.basicConfig(level=logging.DEBUG)
#    else:
#            logging.basicConfig(level=logging.WARNING)
#
#    args, files = parser.parse_known_args()

############################################################
## 1. We check the arguments
#if len(files) != 2:
#    sys.exit("Usage is: spread_sps.py service_products.txt provisioning_port_info.sql")
#
#service_products_file = files[1]
#prov_file = files[2]
#
############################################################
## 2. We extract the list of service products to use in provisioning
#wanted_service_products = list()
#with open(service_products_file, 'r') as fsps:
#    wanted_service_products = [ sp.strip() for sp in fsps]
#
############################################################
## 3. We parse the sql script in search for INSERTs into PORT_INFO table
#parsed_inserts = list()
#with open(prov_file, 'r') as fprov:
#    parsed_inserts = [parse_insert(line) for line in fprov]
#
#port_info_inserts = [parsed_insert for parsed_insert in parsed_inserts if 'TABLE' in parsed_insert and parsed_insert['TABLE'] ==  "PORT_INFO"]
#lines_original_info = dict()
#for insert in port_info_inserts:
#    insert.pop('TABLE')
#    lines_original_info[insert['LINE_ID']] = insert
#
############################################################
## 4. We count the number of lines assigned to each SP
#original_prov = dict()
#for sp in wanted_service_products:
#    original_prov[sp] = 0
#
#for line in port_info_inserts:
#    sp = line["SERVICE_PRODUCT"] 
#    original_prov[sp] = original_prov.get(sp, 0) + 1
#
#logging.debug("Original provisioning: %s" % (original_prov))
#
############################################################
## 5. Now we evenly spread SPs amongst those lines trying to 
##    make the minimum changes.
## 5.1 We calculate the number of lines to assign to each SP
#max_lines_per_sp = len(port_info_inserts) / len(wanted_service_products) + (len(port_info_inserts) % len(wanted_service_products) > 0)
#logging.debug("max lines per sp = %s" % (max_lines_per_sp))
#
## 5.2 We select the lines to which we will change the SP
#pool = list()
#tmp_prov = original_prov.copy()
#for line in port_info_inserts:
#    sp = line["SERVICE_PRODUCT"]
#    if sp not in wanted_service_products or tmp_prov[sp] > max_lines_per_sp:
#        logging.debug("Adding line to pool: %s" % (line))
#        pool.append(line)
#        tmp_prov[sp] = tmp_prov[sp] - 1
#
## 5.3 We go through the list of wanted SPs adding as many 
##     lines from the pool as needed
#for sp in wanted_service_products:
#    logging.debug("---------------------------------------------")
#    logging.debug("Checking %s" % (sp))
#    while len(pool) > 0 and tmp_prov[sp] < max_lines_per_sp:
#        logging.debug(".............................................")
#        logging.debug("Needs one more line because: pool = %s & tmp_prov[sp] = %s" % (len(pool), tmp_prov[sp]))
#        line = pool.pop()
#        logging.debug("Assigning line: %s" % (line))
#        original_sp = line["SERVICE_PRODUCT"]
#        logging.debug("line's original sp: %s" % (original_sp))
#        line["SERVICE_PRODUCT"] = sp
#        logging.debug("line's new sp: %s" % (line["SERVICE_PRODUCT"]))
#        tmp_prov[sp] = tmp_prov[sp] + 1
#
#    logging.debug("%s lines remaining in pool" % (len(pool)))
#
############################################################
## 6. Now we print the new inserts
#with open(prov_file, 'r') as fprov:
#    for line in fprov:
#        parsed_insert = parse_insert(line)
#        if 'TABLE' in parsed_insert and parsed_insert['TABLE'] ==  "PORT_INFO":
#            line_info = lines_original_info[parsed_insert['LINE_ID']]
#            print(line.replace(line_info['SERVICE_PRODUCT'], 
