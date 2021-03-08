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
    # 1. Parse arguments
    #
    desc = "Modify SQL provisioning file to evenly assign SPs to lines provided in a file, all this done per DSLAM, since every one has its own limitations.\n"
    desc += "Usage: spread_sps.py [OPTIONS] DSLAM_NAME \n"
    parser = argparse.ArgumentParser(description=desc)
    parser.add_argument('wanted_service_products_file')
    parser.add_argument('provisioning_file')
    parser.add_argument("--dslam", help="Only take this dslam into account.")
    parser.add_argument("--log", help="Select log level (DEBUG, INFO, WARNING, ERROR, CRITICAL).")
    args = parser.parse_args()

    if args.log:
        logging.basicConfig(level=args.log)
        logging.debug('Setting log level to {}.'.format(args.log))
    else:
        logging.basicConfig(level=logging.WARNING)

    ###########################################################
    # 2. Extract the list of service products to use in provisioning
    wanted_service_products = list()
    with open(args.wanted_service_products_file, 'r') as fsps:
        wanted_service_products = [ "'" + sp.strip() + "'" for sp in fsps ]

    logging.debug('Wanted SPs = {}'.format(wanted_service_products))

    ###########################################################
    # 3. Parse the sql script in search for INSERTs into PORT_INFO table
    parsed_inserts = list()
    with open(args.provisioning_file, 'r') as fprov:
        parsed_inserts = [parse_insert(line) for line in fprov]

    logging.debug('Parsed inserts = {}'.format(parsed_inserts))

    port_info_inserts = [ parsed_insert for parsed_insert in parsed_inserts if (parsed_insert and 'TABLE' in parsed_insert and parsed_insert['TABLE'] ==  "PORT_INFO" and not (args.dslam and "'" + args.dslam + "'" not in parsed_insert['ELEMENT_ID'])) ]

    ###########################################################
    # 4. We count the number of lines assigned to each SP
    sp_count = dict()
    # First we make sure to include those we want, just in case they do
    # not have any line assigned yet and will not appear in the
    # subsequent for loop
    for sp in wanted_service_products:
        sp_count[sp] = 0

    # Count how many appearances each SP does
    for line in port_info_inserts:
        sp = line["SERVICE_PRODUCT"] 
        sp_count[sp] = sp_count.get(sp, 0) + 1
        logging.debug('Line: {}\n--> sp_count={}'.format(line, sp_count))

    logging.debug("Original provisioning has: {}".format(sp_count))

    ###########################################################
    # 5. Now we evenly spread SPs amongst those lines trying to 
    #    make the minimum changes.
    ## 5.1 We calculate the number of lines to assign to each SP
    max_lines_per_sp = len(port_info_inserts) / len(wanted_service_products) + (len(port_info_inserts) % len(wanted_service_products) > 0)
    logging.debug("max lines per sp = {}".format(max_lines_per_sp))

    ## 5.2 We select the lines to which we will change the SP
    pool = list()
    tmp_prov = sp_count.copy()
    for line in port_info_inserts:
        sp = line["SERVICE_PRODUCT"]
        if sp not in wanted_service_products:
            logging.debug("Line candidate for a change (SP not wanted): {}={}".format(line['LINE_ID'], sp))
            pool.append(line)

    # TODO: stop checking lines if no SP has more lines than max_lines_per_sp
    for line in port_info_inserts:
        sp = line["SERVICE_PRODUCT"]
        logging.debug("Checking {}={}\nFuture provisiong looks like: {}".format(line['LINE_ID'], sp, tmp_prov))
        if tmp_prov[sp] > max_lines_per_sp:
            logging.debug("Line candidate for a change (SP still has too many lines).")
            pool.append(line)
            tmp_prov[sp] = tmp_prov[sp] - 1

    ## 5.3 We go through the list of wanted SPs adding as many 
    ##     lines from the pool as needed
    conversion = dict()
    for sp in wanted_service_products:
        logging.debug("---------------------------------------------")
        logging.debug("Adding lines to {}".format(sp))
        while len(pool) > 0 and tmp_prov[sp] < max_lines_per_sp:
            logging.debug(".............................................")
            logging.debug("Needs one more line because: pool = %s & tmp_prov[sp] = %s" % (len(pool), tmp_prov[sp]))

            # this line is going to be assigned for a change so we remove it
            # from the pool of candidates
            line = pool.pop()

            # we schedule the conversion
            conversion[line['LINE_ID']] = { 'OLD': line['SERVICE_PRODUCT'], 'NEW': sp }
            logging.debug("Conversion scheduled: {} --> {}".format(line['LINE_ID'], conversion[line['LINE_ID']]))
            tmp_prov[sp] = tmp_prov[sp] + 1

        logging.debug("%s lines remaining in pool" % (len(pool)))
    
    ###########################################################
    # 6. Now we print the new inserts
    with open(args.provisioning_file, 'r') as fprov:
        for line in fprov:
            parsed_insert = parse_insert(line)
            if parsed_insert and 'TABLE' in parsed_insert and parsed_insert['TABLE'] ==  "PORT_INFO" and parsed_insert['LINE_ID'] in conversion:
                line_id = parsed_insert['LINE_ID']
                logging.debug('Original line:\n{}'.format(line))
                new_line = line.replace(conversion[line_id]['OLD'], conversion[line_id]['NEW'])
                logging.debug('Converted line:\n{}'.format(new_line))
                sys.stdout.write(new_line)
            else:
                sys.stdout.write(line)
