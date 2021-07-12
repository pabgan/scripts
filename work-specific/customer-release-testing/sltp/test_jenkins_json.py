#!/usr/bin/python2
#
#                               ASSIA, Inc.
#                     Confidential and Proprietary
#                         ALL RIGHTS RESERVED.
#
#      This software is provided under license and may be used
#      or distributed only in accordance with the terms of
#      such license.
#
# History: Date        By whom     What
#          2020-10-15  pganuza        created
#
# CVS version control block - do not edit manually
#  $Author: pganuza $
#  $Revision: 1.7 $
#  $Date: 2021/01/29 07:38:46 $
#  $Source: /cvs/dsloExpresseAdditional/tools/releaseTestingTools/system_level_test_plan/src/bin/test_jenkins_json.py,v $

#############################
# README: This test fetches from Jenkins the last build for the view and job 
#         passed as parameters in Json format, parses it and writes a table 
#         with the summary in the output path.
#         It also creates another file, with extension `result`, with either:
#            - PASS: If no SKIPPED or FAILED test was found.
#            - FAIL: If any FAILED test is found.
#            - MANUAL: In any other case.
import sys, os
import urllib, json
from datetime import datetime
from writers.plain_text_writer import textfile_writer
from readers.db_reader import db_reader
from readers.config_reader import ConfigReader

#############################
# 0. Auxiliary functions
def getJson(url):
    data = None
    js = None
    try:
        fhand = urllib.urlopen(url)
        data = fhand.read().decode()
        js = json.loads(data)
    except:
        print("ERROR: Could not download valid json from %s" % url)
        print("------- Data downloaded -----------")
        print(data)
        print("-----------------------------------")
        file_result.write_text('ERROR')
        file_result.close()
        file_dat.close()
        exit(1)

    return js

#############################
# 1. Check input for correctness
if len(sys.argv) != 5:
    print("Usage: test_jenkins_json.py JOB_CONFIG_KEY CONFIG_PATH OUTPUT_FILE_NAME OUTPUT_PATH")
    print("Example: test_jenkins_json.py 'napi_job_name' '../../releases/telefonica_colombia/5.5.3.0/config.properties' 'output_test_3.18' '../../../releases/telefonica_argentina/5.5.0/output/'")
    exit(1)

job_config_key = sys.argv[1]
config_file_path = sys.argv[2]
output_file_name = sys.argv[3]
output_path = sys.argv[4]

# 1.1 Read config for needed parameters
config = ConfigReader(config_file_path).properties
db_username = config['db_schema_name']
dep_job = config['deployment_job_name']
try:
    test_job = config[job_config_key]
except KeyError:
    print("ERROR: '%s' is not defined in '%s'" % (job_config_key, config_file_path))
    exit(1)

#############################
# 2. Define global variables
# Possible results
PASSED = 'PASS'
FAILED = 'FAIL'
MANUAL = 'MANUAL'

# We resolve the urls we need
url_timeStamp_template = "http://rc-build-01.assia-inc.com:8080/job/{0}/lastCompletedBuild/api/json/buildTimeStamp"
url_testReport_template = "http://rc-build-01.assia-inc.com:8080/job/{0}/lastCompletedBuild/testReport/api/json?depth=3&pretty=true&tree=suites%5Bcases%5BclassName,name,status%5D%5D"

url_dep_timeStamp = url_timeStamp_template.format(dep_job)
url_test_testReport = url_testReport_template.format(test_job)
url_test_timestamp = url_timeStamp_template.format(test_job)

# We open result files
file_dat_path = os.path.join(output_path, output_file_name + '.dat')
file_dat = textfile_writer(file_dat_path)

file_result_path = os.path.join(output_path, output_file_name + '.result')
file_result = textfile_writer(file_result_path)

#############################
# 4. Process results, because IF WE GOT HERE, RESULTS ARE VALID.
#    For this, we will parse JSON into a dictionary in which every item's key is a test's package
#    name and the value is a dictionary with the overall results (package name, number of PASS,
#    SKIP and FAIL) of every test under that package.
#
# We will assume everything is fine until found otherwise
overall_result = PASSED
results_summary = dict()

js = getJson(url_test_testReport)
for suite in js["suites"]:
    classname = suite["cases"][0]["className"]
    # From the classname we will remove the classname itself to get the name
    # of the package, and from the package's name we will remove the always
    # common 'com.assia.dslo.' prefix for readability
    package = classname.replace('com.assia.', '')
    package = package[:package.rfind('.')]

    result_summary = results_summary.get(package, {'PACKAGE': package, 'PASSED': 0, 'FAILED': 0, 'SKIPPED': 0, 'FIXED': 0})
    for case in suite["cases"]:
        status = case["status"]
        result_summary[status] = result_summary.get(status, 0) + 1

        # If we find any FAILED test then the end result shall be FAILED
        if status == 'FAILED':
            overall_result = FAILED

    results_summary[package] = result_summary

#############################
# 5. Write results
# 5.1 Write file with summary of results' table 
file_dat.write_dictlist_as_table(results_summary.values())
file_dat.write_text("\n")

# 5.2 Write file with the overall test evaluation
with open(file_result_path, 'w') as file_result:
    file_result.write(overall_result + '\n')

