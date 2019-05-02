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

#This script is to add features into hom SNP/INDEL vcfs

if [ $# -ne 1 ]
then
  echo ""
    echo "Usage: 4-2.add-1-feature-gq.sh input_vcf"
    echo "Example: 4-2.add-1-feature-gq.sh ./pPE150-100000W-1-sorted.bam_raw.vcf_INDEL_hom.vcf "
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
  echo "Warning: The input file $input_vcf does not exist in 4-2.add-1-feature-gq.sh, exit."
  echo ""
  exit 1
fi

echo "####    STEP 4.2 : add features into hom SNP/INDEL vcfs    ####"

#generate GQ
cat $input_vcf | grep -v "#" | tr ":" "\t" | cut -f 17 > ${input_vcf}-gq
#add the features back into the original VCF
paste $input_vcf ${input_vcf}-gq > ${input_vcf}.ok
#delete intermedia files
rm ${input_vcf}-gq
echo $input_vcf finish! 
