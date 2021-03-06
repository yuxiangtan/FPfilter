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

#This script is to get the to-be-filtered from the hom-INDEL


if [ $# -ne 1 ]
then
  echo ""
    echo "Usage: 5-4.Filter-the-11-indel.sh input_vcf"
    echo "Example: 5-4.Filter-the-11-indel.sh ./pPE150-100000W-1-sorted.bam_raw.vcf_INDEL_hom.vcf.ok "
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
  echo "Warning: The input file $input_vcf does not exist in 5-4.Filter-the-11-indel.sh, exit."
  echo ""
  exit 1
fi

echo "####    STEP 5.4 : get the to-be-filtered from the hom-INDEL    ####"
# 11 12 13 14 15 : ADR MQRanksum QD GQ DP 

cat $input_vcf | awk '{ if( $11 < 12 ) {print $0} }' | cut -f 1-10  > ${input_vcf}.filtered-GQ_INDEL_hom.vcf

echo "$input_vcf finish !"
