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

#This script is to split the vcf into 4 subgroups combined of 01(Heterozygous)/11(Homozygous) * SNP/INDEL

################
#Library file requirement:
#rtg must be installed by anaconda
################


if [ $# -ne 1 ]
then
  echo ""
    echo "Usage: 3.splitVCF-to-4type.sh input_vcf"
    echo "Example: 3.splitVCF-to-4type.sh ./pPE150-100000W-1-sorted.bam_raw.vcf "
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
  echo "Warning: The input file $input_vcf does not exist in 3.splitVCF-to-4type.sh, exit."
  echo ""
  exit 1
fi


echo "####    STEP 3 : split the vcf to 4 type 01 11 snp indel    ####"
echo $input_vcf "begin"
echo $input_vcf split SNP 
rtg vcffilter --snps-only -i $input_vcf -o ${input_vcf}_SNP

echo ""
echo $input_vcf split INDEL 
rtg vcffilter --non-snps-only -i $input_vcf -o ${input_vcf}_INDEL

echo "____________________________________________________________________________________________________"
cat $input_vcf | grep "#" > ${input_vcf}HEAD
zcat ${input_vcf}_SNP.vcf.gz | grep "0/1" > ${input_vcf}_SNP_het.vcf
zcat ${input_vcf}_SNP.vcf.gz | grep "1/1" > ${input_vcf}_SNP_hom.vcf
zcat ${input_vcf}_INDEL.vcf.gz | grep "0/1" > ${input_vcf}_INDEL_het.vcf
zcat ${input_vcf}_INDEL.vcf.gz | grep "1/1" > ${input_vcf}_INDEL_hom.vcf
echo $input_vcf finish!
echo "____________________________________________________________________________________________________"
