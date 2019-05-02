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

#This script is to get the to-be-filtered from the het-INDEL


if [ $# -ne 1 ]
then
  echo ""
    echo "Usage: 5-2.Filter-the-01-indel.sh input_vcf"
    echo "Example: 5-2.Filter-the-01-indel.sh ./pPE150-100000W-1-sorted.bam_raw.vcf_INDEL_het.vcf.ok "
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
  echo "Warning: The input file $input_vcf does not exist in 5-2.Filter-the-01-indel.sh, exit."
  echo ""
  exit 1
fi

echo "####    STEP 5.2 : get the to-be-filtered from the het-INDEL    ####"

# 11 12 13 14 15 : ADR MQRanksum QD GQ DP 
cat $input_vcf | awk '{ if( $11 > 3 && $12 <= -1 ) {print $0} }' | cut -f 1-10  > ${input_vcf}.filtered-MQR-ADR1_INDEL.vcf

cat $input_vcf | awk '{ if( $12 > 3 && $13 > 25 ) {print $0} }' | cut -f 1-10  > ${input_vcf}.filtered-MQR-QD1_INDEL.vcf

cat $input_vcf | awk '{ if( $15 > 2000 ) {print $0} }' | cut -f 1-10  > ${input_vcf}.filtered-DP.vcf

#bing 
cat ${input_vcf}.filtered-MQR-ADR1_INDEL.vcf ${input_vcf}.filtered-MQR-QD1_INDEL.vcf ${input_vcf}.filtered-DP.vcf | sort | uniq > bing-indel.vcf
#delete intermedia files
rm ${input_vcf}.filtered-MQR-ADR1_INDEL.vcf ${input_vcf}.filtered-MQR-QD1_INDEL.vcf ${input_vcf}.filtered-DP.vcf
echo "$input_vcf finish !"
