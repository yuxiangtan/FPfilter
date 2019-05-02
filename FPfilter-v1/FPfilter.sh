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

#This script is the main process of FPfilter

################
#Library file requirement:
#rtg must be installed by anaconda
#vcf-sort must be installed by anaconda
################


if [ $# -ne 2 ]
then
  echo ""
    echo "Usage: FPfilter.sh input_vcf FPfilter_path"
    echo "Example: FPfilter.sh ./pPE150-100000W-1-sorted.bam_raw.vcf miniconda2/pkgs/FPfilter_vXXXXXX/lib/FPfilter/"
    echo ""
    echo "input_vcf - The target vcf file."
    echo "FPfilter_path - The path of FPfilter scripts."
    exit 1
fi


#name the parameters
input_vcf=$1
FPfilter_path=$2

#check files
if [ ! -s $input_vcf ] 
then
  echo ""
  echo "Warning: The input file $input_vcf does not exist in FPfilter.sh, exit."
  echo ""
  exit 1
fi


echo $input_vcf "all begin!"


#step1
${FPfilter_path}/3.splitVCF-to-4type.sh ${input_vcf} 

#step4 add features
${FPfilter_path}/4-1.add-to-het-4-feature-adr-mqr-gq-dp.sh ${input_vcf}_INDEL_het.vcf 
${FPfilter_path}/4-1.add-to-het-4-feature-adr-mqr-gq-dp.sh ${input_vcf}_SNP_het.vcf 
${FPfilter_path}/4-2.add-1-feature-gq.sh ${input_vcf}_INDEL_hom.vcf
${FPfilter_path}/4-2.add-1-feature-gq.sh ${input_vcf}_SNP_hom.vcf 

#step5 filter
${FPfilter_path}/5-1.Filter-the-01-snp.sh ${input_vcf}_SNP_het.vcf.ok
${FPfilter_path}/5-2.Filter-the-01-indel.sh ${input_vcf}_INDEL_het.vcf.ok

${FPfilter_path}/5-3.Filter-the-11-snp.sh ${input_vcf}_SNP_hom.vcf.ok
${FPfilter_path}/5-4.Filter-the-11-indel.sh ${input_vcf}_INDEL_hom.vcf.ok

#step6 summarization
${FPfilter_path}/6.Paste-sort.sh $input_vcf ${FPfilter_path}
