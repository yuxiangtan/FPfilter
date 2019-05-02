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

#This script is to get the to-be-filtered from the het-SNP


if [ $# -ne 1 ]
then
  echo ""
    echo "Usage: 5-1.Filter-the-01-snp.sh input_vcf"
    echo "Example: 5-1.Filter-the-01-snp.sh ./pPE150-100000W-1-sorted.bam_raw.vcf_SNP_het.vcf.ok "
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
  echo "Warning: The input file $input_vcf does not exist in 5-1.Filter-the-01-snp.sh, exit."
  echo ""
  exit 1
fi




echo "####    STEP 5.1 : get the to-be-filtered from the het-SNP    ####"
# 11 12 13 14 15 : ADR MQRanksum QD GQ DP 
#to put variables into the function
#cat -v ADR1=$ADR1 -v MQR1=$MQR1 $input_vcf | awk '{ if( $11>ADR1 && $12<MQR1 ) {print $0} }' | cut -f 1-10  > ${input_vcf}.filtered-MQR-ADR1_SNP.vcf

cat $input_vcf | awk '{ if( $11 > 5 && $12 < -2 ) {print $0} }' | cut -f 1-10  > ${input_vcf}.filtered-MQR-ADR1_SNP.vcf
cat $input_vcf | awk '{ if( $11 < 0.5 && $12 > 3 ) {print $0} }' | cut -f 1-10  > ${input_vcf}.filtered-MQR-ADR2_SNP.vcf
cat $input_vcf | awk '{ if( $11 < 0.2 && $12 > 0.5 ) {print $0} }' | cut -f 1-10  > ${input_vcf}.filtered-MQR-ADR3_SNP.vcf
cat $input_vcf | awk '{ if( $12 > 5 && $13 > 10 ) {print $0} }' | cut -f 1-10  > ${input_vcf}.filtered-MQR-QD1_SNP.vcf
cat $input_vcf | awk '{ if( $12 > 0 && $13 > 30 ) {print $0} }' | cut -f 1-10  > ${input_vcf}.filtered-MQR-QD2_SNP.vcf
cat $input_vcf | awk '{ if( $12 < -9.5 && $13 > 20 ) {print $0} }' | cut -f 1-10  > ${input_vcf}.filtered-MQR-QD3_SNP.vcf
cat $input_vcf | awk '{ if( $6 > 4000 ) {print $0} }' | cut -f 1-10  > ${input_vcf}.filtered-QU.vcf

#bing 
cat ${input_vcf}.filtered-MQR-ADR1_SNP.vcf ${input_vcf}.filtered-MQR-ADR2_SNP.vcf ${input_vcf}.filtered-MQR-ADR3_SNP.vcf ${input_vcf}.filtered-MQR-QD1_SNP.vcf ${input_vcf}.filtered-MQR-QD2_SNP.vcf ${input_vcf}.filtered-MQR-QD3_SNP.vcf ${input_vcf}.filtered-QU.vcf | sort | uniq > bing-snp.vcf

#delete intermedia files
rm ${input_vcf}.filtered-QU.vcf ${input_vcf}.filtered-MQR-ADR*_SNP.vcf ${input_vcf}.filtered-MQR-QD*_SNP.vcf
echo "$input_vcf finish !" 
