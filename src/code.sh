#!/bin/bash
# nimagen_to_GEL_VCF 1.0.0
# Generated by dx-app-wizard.
#
# Basic execution pattern: Your app will run on a single machine from
# beginning to end.
#
# Your job's input variables (if any) will be loaded as environment
# variables before this script runs.  Any array inputs will be loaded
# as bash arrays.
#
# Any code outside of main() (or any entry point you may add) is
# ALWAYS executed, followed by running the entry point itself.
#
# See https://documentation.dnanexus.com/developer for tutorials on how
# to modify this file.

# The following line causes bash to exit at any point if there is any error
# and to output each line as it is executed -- useful for debugging
set -e -x -o pipefail

main() {

    # input variables
    echo "installing bcftools"
    cd /packages
    tar -jxvf bcftools-1.13.tar.bz2
    cd bcftools-1.13
    ./configure --prefix=/packages
    make
    make install
    export PATH=/packages/bin:$PATH

    echo "installing htslib"
    cd /packages
    tar -jxvf htslib-1.13.tar.bz2
    cd htslib-1.13
    ./configure --prefix=/packages
    make
    make install
    export PATH=/packages/bin:$PATH

    # Store the vcf file name as a string
    vcf_file=$input_vcf_name

    # Remove .vcf extension from vcf file name
    vcf_prefix="${vcf_file%.vcf.gz}"

    # Download vcf and index files
    dx download "$input_vcf" -o "$vcf_file"
    dx download "$input_vcf_index" -o "$input_vcf_index_name"
    dx download "$fasta_file" -o fasta_file
    dx download "$header_txt" -o header_txt


    # Use bcftools annotate to fill in missing header lines
    #less update_header.txt
    ##fileDate=
    ##source=my_assay=nimagen_v0.1

    bcftools annotate -h header_txt $vcf_file > correct_header.vcf

    # Update reference fasta

    sed 's+file://genome/GRCh38.no_alt_analysis_set.fa+http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/GRCh38_reference_genome/GRCh38_full_analysis_set_plus_decoy_hla.fa+g' correct_header.vcf > correct_header2.vcf

    # Update date in vcf 

    sed "s/yyyymmdd/$(date '+%Y%m%d')/g" correct_header2.vcf > correct_header_date.vcf

    # Split multiallelic variants

    bcftools norm -f fasta_file -m -any correct_header_date.vcf -o correct_header_date_split_multiallelics.vcf

    # Output GEL vcf should be gunzipped and indexed
    gel_vcf="${vcf_prefix}_gel_compatible.vcf.gz"
    bgzip -c correct_header_date_split_multiallelics.vcf > "${gel_vcf}"


	tabix -fp vcf $gel_vcf


	# upload output files
	GEL_vcf=$(dx upload $gel_vcf --brief)
	GEL_vcf_index=$(dx upload "${gel_vcf}.tbi" --brief)

	dx-jobutil-add-output GEL_vcf "$GEL_vcf" --class=file
	dx-jobutil-add-output GEL_vcf_index "$GEL_vcf_index" --class=file
}
