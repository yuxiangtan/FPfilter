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

#This script is to paste and sort the result for summarization

################
#Library file requirement:
#vcf-sort must be installed by anaconda
################


if [ $# -ne 2 ]
then
  echo ""
    echo "Usage: 6.Paste-sort.sh input_vcf "
    echo "Example: 6.Paste-sort.sh ./pPE150-100000W-1-sorted.bam_raw.vcf miniconda2/pkgs/FPfilter_vXXXXXX/lib/FPfilter/"
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
  echo "Warning: The input file $input_vcf does not exist in 6.Paste-sort.sh, exit."
  echo ""
  exit 1
fi

echo "####    step6 paste and sort the result    ####"
cat ${input_vcf}_INDEL_hom.vcf.ok.filtered-GQ_INDEL_hom.vcf ${input_vcf}_SNP_hom.vcf.ok.filtered-GQ_SNP_hom.vcf bing-indel.vcf bing-snp.vcf > filter.vcf
rm ${input_vcf}_INDEL_hom.vcf.ok.filtered-GQ_INDEL_hom.vcf ${input_vcf}_SNP_hom.vcf.ok.filtered-GQ_SNP_hom.vcf bing-indel.vcf bing-snp.vcf 
grep -v "#" ${input_vcf} > file

grep "#" ${input_vcf} > ${input_vcf}_filtered_FP.vcf
grep "#" ${input_vcf} > ${input_vcf}_TP_after_filtered.vcf

#use uniq -u to filtered the duplicates(which are the locis in the filter.vcf)
sort file filter.vcf | uniq -u >> ${input_vcf}_TP_after_filtered.vcf
cat filter.vcf >> ${input_vcf}_filtered_FP.vcf

#last need sort cat file.vcf | vcf-sort > out.vcf 
#it is to sort by col 2 and then by col 1
cat ${input_vcf}_TP_after_filtered.vcf | ${FPfilter_path}/vcf-sort > ${input_vcf}_TP_after_filtered_sorted.vcf
cat ${input_vcf}_filtered_FP.vcf | ${FPfilter_path}/vcf-sort > ${input_vcf}_filtered_FP_sorted.vcf

#check
if [ ! -f ${input_vcf}_TP_after_filtered_sorted.vcf ]
then
  echo ""
  echo "Warning: The file ${input_vcf}_TP_after_filtered_sorted.vcf does not exist exit!"
  echo ""
  exit 1
fi

if [ ! -f ${input_vcf}_filtered_FP_sorted.vcf ]
then
  echo ""
  echo "Warning: The file ${input_vcf}_filtered_FP_sorted.vcf does not exist exit!"
  echo ""
  exit 1
fi

#finish
echo $input_vcf all finish

####  rm the tmp 
rm *ok
rm *tbi
rm *HEAD
rm file
rm filter.vcf
rm *gz
rm ${input_vcf}_TP_after_filtered.vcf
rm ${input_vcf}_filtered_FP.vcf