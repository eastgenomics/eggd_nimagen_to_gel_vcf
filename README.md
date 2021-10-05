<!-- dx-header -->
# nimagen_to_gel_vcf(DNAnexus Platform App)

## What does this app do?
App to convert sentieon dnaseq output VCF to VCF meeting GEL specification for WGS SNP genotyping

## What are typical use cases for this app?
This app may be executed as a standalone app.

## What data are required for this app to run?
This app requires a VCF and its index as inputs. The genome reference file and the header_v*.txt file.
Optionally it also may take an integer to set a MAPQ threshold, or not perform removal of multimapped reads.

## What does this app output?
This app outputs a gel compatible VCF and an index file.

This is the source code for an app that runs on the DNAnexus Platform.
For more information about how to run or modify it, see
https://documentation.dnanexus.com/.

#### This app was made by EMEE GLH
