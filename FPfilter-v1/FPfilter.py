# -*- coding: cp936 -*-

#   Copyright {2018} Yuxiang Tan, Yu Zhang
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.


"""
This script is the main process of FPfilter
All the output will be generated in the current-working folder
=============================
Usage: python FPfilter.py -v input_vcf -p FPfilter_path
-h help
-v The vcf file as input to be filtered								    *[No default value]
-p The path of FPfilter scripts             		                    *[No default value]

============================
Python & Module requirement:
Versions: 2.7 or above
Module: No additional Python Module is required.
============================
Library file requirement:
Not Standalone version, few library file is required.
rtg must be installed by anaconda
============================
"""

##By Yuxiang Tan
##Contact: yuxiang.tan@gmail.com
##Compatible Python Version:2.7 or above

###Code Framework

import os.path, sys, csv, getopt, re, subprocess, os

if __name__ == "__main__":
    import os.path, sys, csv, getopt, re, subprocess, os
   
    list_args = sys.argv[1:]
    
    if '-h' in list_args:
        print (__doc__)
        sys.exit(0)
    elif len(list_args) <2 or '-p' not in list_args or '-v' not in list_args:
        print (__doc__)
        sys.exit(1)
    else:
        optlist, cmd_list = getopt.getopt(sys.argv[1:], 'hv:p:z')
    
    for opt in optlist:
        if opt[0] == '-h':
            print (__doc__); sys.exit(0)
        elif opt[0] == '-v': input_vcf =opt[1]
        elif opt[0] == '-p': FPfilter_path =opt[1]
    
    LOG_ERR="error.log"
    log_error=open(LOG_ERR,"a")
    #check files
    if not os.path.exists(input_vcf):
        print ("Warning: The input file input_vcf does not exist in FPfilter.sh, exit.")
        log_error.write("Warning: The input file input_vcf does not exist in FPfilter.sh, exit.\n"); sys.exit(1)
        
    if not os.path.exists(FPfilter_path):
        print (FPfilter_path)
	print ("Warning: The path of FPfilter folder is not correct, exit.\n")
        log_error.write("Warning: The path of FPfilter folder is not correct, exit.\n"); sys.exit(1)
        
    #step1
    s1_cmd="sh "+FPfilter_path+"/3.splitVCF-to-4type.sh "+input_vcf
    subprocess.call(s1_cmd,shell=True)
    
    #step2
    s2a_cmd="sh "+FPfilter_path+"/4-1.add-to-het-4-feature-adr-mqr-gq-dp.sh "+input_vcf+"_INDEL_het.vcf"
    subprocess.call(s2a_cmd,shell=True)
    s2b_cmd="sh "+FPfilter_path+"/4-1.add-to-het-4-feature-adr-mqr-gq-dp.sh "+input_vcf+"_SNP_het.vcf"
    subprocess.call(s2b_cmd,shell=True)
    s2c_cmd="sh "+FPfilter_path+"/4-2.add-1-feature-gq.sh "+input_vcf+"_INDEL_hom.vcf"
    subprocess.call(s2c_cmd,shell=True)
    s2d_cmd="sh "+FPfilter_path+"/4-2.add-1-feature-gq.sh "+input_vcf+"_SNP_hom.vcf"
    subprocess.call(s2d_cmd,shell=True)
    
    #step3 filter
    s3a_cmd="sh "+FPfilter_path+"/5-1.Filter-the-01-snp.sh "+input_vcf+"_SNP_het.vcf.ok"
    subprocess.call(s3a_cmd,shell=True)
    s3b_cmd="sh "+FPfilter_path+"/5-2.Filter-the-01-indel.sh "+input_vcf+"_INDEL_het.vcf.ok"
    subprocess.call(s3b_cmd,shell=True)
    s3c_cmd="sh "+FPfilter_path+"/5-3.Filter-the-11-snp.sh "+input_vcf+"_SNP_hom.vcf.ok"
    subprocess.call(s3c_cmd,shell=True)
    s3d_cmd="sh "+FPfilter_path+"/5-4.Filter-the-11-indel.sh "+input_vcf+"_INDEL_hom.vcf.ok"
    subprocess.call(s3d_cmd,shell=True)
    
    #step4 summarization
    s4_cmd="sh "+FPfilter_path+"/6.Paste-sort.sh "+input_vcf+" "+FPfilter_path
    subprocess.call(s4_cmd,shell=True)


    