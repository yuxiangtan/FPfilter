#!/bin/bash

#   Copyright {2015} Yuxiang Tan, Yu Zhang
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

#This script is to add features into het SNP/INDEL vcfs 

if [ $# -ne 1 ]
then
  echo ""
    echo "Usage: 4-1.add-to-het-4-feature-adr-mqr-gq-dp.sh input_vcf "
    echo "Example: 4-1.add-to-het-4-feature-adr-mqr-gq-dp.sh ./pPE150-100000W-1-sorted.bam_raw.vcf_INDEL_het.vcf "
    echo ""
    echo "input_vcf - The target vcf file."
    exit 1
fi


#name the parameters
input_vcf=$1


#check files
if [ ! -s $input_vcf ] 
then
  echo ""
  echo "Warning: The input file $input_vcf does not exist in 4-1.add-to-het-4-feature-adr-mqr-gq-dp.sh, exit."
  echo ""
  exit 1
fi


echo "####    STEP 4.1 : add features into het SNP/INDEL vcfs    ####"
echo $input_vcf begin
#pre calculate ADR
cat $input_vcf | cut -f 10 | tr ":" "\t" | grep -v "#" | cut -f 1-3 | tr "," "\t" | grep -v "pP" > ${input_vcf}.a
cat ${input_vcf}.a | cut -f 2 > ${input_vcf}2
cat ${input_vcf}.a | cut -f 3 > ${input_vcf}3
cat ${input_vcf}2 | awk '{print $1+1}' > ${input_vcf}2-p
cat ${input_vcf}3 | awk '{print $1+1}' > ${input_vcf}3-p
paste ${input_vcf}2-p ${input_vcf}3-p > ${input_vcf}23-p
#generate ADR 
cat ${input_vcf}23-p | awk '{print $1/$2}' > ${input_vcf}23-r
#generate MQR
cat ${input_vcf} | cut -f 8 | tr ";" "\t" | cut -f 12 | sed "s/MQRankSum=//g" > ${input_vcf}-mr
#generate QD
cat $input_vcf | grep -v "#" | tr ";" "\t" | cut -f 20 | sed "s/QD=//g" > ${input_vcf}-qd
#generate GQ
cat $input_vcf | grep -v "#" | tr ":" "\t" | cut -f 17 > ${input_vcf}-gq
#generate DP
cat $input_vcf | grep -v "#" | tr ":" "\t" | cut -f 16 > ${input_vcf}-dp
#add the features back into the original VCF
paste $input_vcf ${input_vcf}23-r ${input_vcf}-mr ${input_vcf}-qd ${input_vcf}-gq ${input_vcf}-dp > ${input_vcf}.ok
#delete intermedia files
rm ${input_vcf}.a ${input_vcf}2 ${input_vcf}2-p ${input_vcf}-mr ${input_vcf}3 ${input_vcf}3-p ${input_vcf}23-p ${input_vcf}23-r ${input_vcf}-qd ${input_vcf}-gq ${input_vcf}-dp
echo $input_vcf finish!
