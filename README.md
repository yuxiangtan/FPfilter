#FPfilter
<li>FPfilter is a false-positive specific filter for vcf files from whole genome sequencing. It is proved to be more false-positive specific than GATK hard filter </li>


##Publications


##Test Datasets
<li>The test vcf file "PE150-example.vcf" is provided in the script folder. </li>



##Setup
<li>To run FPfilter, you need to have anaconda installed in your Linux system.</li>
<li>After that, you need to get FPfilter from binstar and create the running environment by:</li>
<li> conda create -c yuxiang fpfilter -n $env_name #(Recommendation: use FPF with version number as the env_name.) </li>
<li>Once it is setup correctly, it will tell you how to activate the environment. For example: source activate $env_name </li>

##Input Data Format</li>
<li>Regular vcf, such as from GATK.</li>


##How to Run
<li>Before running FPfilter, you need to activate the FPfilter environment by:</li>
<li> source activate $env_name #(The one used in the setup step) </li>
<li>Running FPfilter is as simple as running a single command line by just typing "FPfilter -v vcf-file -p FPfilter_path". </li>
<li>[Details of all parameters: please see the help information in each FPfilter version for latest updates.]</li>
<li>*Note1: the output directory is the folder in which the vcf file is located. In order to avoid running error, the current working folder should be the folder in which the vcf file is located.*</li>
<li>*Note2: generally, the FPfilter_path is under path_of_miniconda2/envs/env_name/lib/FPfilter/. You can get the path_of_miniconda2 by "which FPfilter" and change "bin" to "lib" in the path.*</li>

##Parameters
###All the parameters are required.
<li>-h help</li>
<li>-v The vcf file as input to be filtered								    *[No default value]</li>
<li>-p The path of FPfilter scripts             		                    *[No default value]</li>


##Output
###Final Output Stucture
<li>${input_vcf}_TP_after_filtered.vcf: the "TP" locations which passed the filter.</li>
<li>${input_vcf}_filtered_FP.vcf :the "false positive" locations which were filtered.</li>



