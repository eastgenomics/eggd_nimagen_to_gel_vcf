<!-- dx-header -->
# eggd_nimagen_to_gel_vcf(DNAnexus Platform App)

## What does this app do?
### This app converts sentieon dnaseq output VCF to a VCF meeting Genomics England (GEL) specifications for WGS SNP genotyping

## What data are required for this app to run?
This app requires a VCF and its index as inputs. The genome reference file and the header_v*.txt file.

## What does this app output?
This app outputs a gel compatible VCF and an index file.

## What does this app do?
### This app uses bcftools to create a GEL compatible vcf by:
- Corrects the VCF header (reference, date, source field, correct sample name)
- Splits multiallelic variants
- Adds the PASS tag to SNPs with DP > 99
- Adds LOW_DP tag to SNPs with DP < 99
- Produces a GEL compatible VCF and its index

## What are the GEL requirements

|  App 	| Version  	|
|---	|---	|
|Genome version GRCh38       |reference file that Genomics England |
|“chr” prefix   |chr1, chr2, chr3, chr4, chr5, ..., chr21, chr22, chrX, chrY|
|One sample per vcf|single sample VCF|_
|Header with appropriate tags|fileDate and source|
|source field          |Must be from an enumeration reflecting the standardised names of the assays used for genotyping|
|Sample ID column name	|primary_sample_id_in_glh_lims|
|VCF fields      |GT, PL, GQ|
|Biallelic SNVs           |The ALT field must not contain more than one value|
|PASS variants  |DP > 99|
|LOW_DP variants           |DP < 99|
|Variants normalised             |parsimonious and left-aligned|
