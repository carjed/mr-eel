---
layout: archive
title: "Mr. Eel: Mutation Rate Annotation Utility"
output:
  html_document:
    toc: true
---

## Overview
**Please note that this web app is in beta, and is presently hosted on an Amazon EC2 micro instance with limited CPU and RAM. As such, problems may arise if multiple sessions are running concurrently. We apologize for any inconvenience.**

Mr. Eel is an annotation utility for **M**utation **R**ate **E**stimation using **E**xtremely rare variants and **L**ocal sequence context. It is designed to quickly annotate single-nucleotide variants with their estimated mutation rate, using the method described in [citation pending](#).

### Formatting Input
Files must be uploaded as a tab-delimited text file, and **must** start with the following 4 columns:

| CHR | POS    | REF | ALT |    V1    |       V2            |       V3         |
|-----|--------|-----|-----|----------|---------------------|------------------|
|  -  | -      | -   | -   |    -     |       -             |       -          |

- Other columns may be included in the input file, and will be preserved in the output.
- Input files can be processed with or without a column header in the first row. If your input file contains a header, the same column names will carry over to the output. If your input file contains additional columns but no header, arbitrary names will be assigned to these columns in the output.
- Only autosomal positions will be processed; positions on sex chromosomes, mitochondrial DNA, or unplaced contigs will be discarded. Input data does not need to be sorted, but performance will be **much** faster using sorted input.
- An example input file is available [here](http://www.jedidiahcarlson.com/assets/test_sites.txt)
- Sites should be mapped to build 37 (hg19) of the human reference genome. Specifically, this utility uses the 1000 Genomes assembly file, available at [human_g1k_v37.fasta](ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/). Support for other builds will be implemented in a future release.
- VCF files are not currently supported, but can be quickly converted to the desired format using [bcftools](https://samtools.github.io/bcftools/bcftools.html):

```
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\n' in.vcf > positions.txt"
```

### Output
The processed output will be identical to the input, with the addition of a column containing the estimated relative mutation rate for each site:

| CHR | POS    | REF | ALT | CATEGORY | MU                  | -                |
|-----|--------|-----|-----|----------|---------------------|------------------|
| 1   | 767658 | G   | T   | GC_TA    | 0.00338503160303719 |                  |
| 1   | 771925 | G   | A   | GC_AT    | 0.101687967205209   |                  |
| 1   | 871509 | G   | C   | GC_CG    | 0.00344711848109074 |                  |
| 1   | 904483 | G   | A   | GC_AT    | 0.00584652048509416 |                  |

If the **Include sequence motif?** option is selected, an additional column containing the sequence motif (and its reverse complement) will also be included:

| CHR | POS    | REF | ALT | CATEGORY | MU                  | MOTIF            |
|-----|--------|-----|-----|----------|---------------------|------------------|
| 1   | 767658 | G   | T   | GC_TA    | 0.00338503160303719 | AGCCTTT(AAAGGCT) |
| 1   | 771925 | G   | A   | GC_AT    | 0.101687967205209   | AGCCGGT(ACCGGCT) |
| 1   | 871509 | G   | C   | GC_CG    | 0.00344711848109074 | GCCCCGG(CCGGGGC) |
| 1   | 904483 | G   | A   | GC_AT    | 0.00584652048509416 | GTTCTAC(GTAGAAC) |

If a value is entered in the **"Scale rates to:"** field, relative mutation rates will be scaled to a per-site, per-generation mutation rate, calibrated to the value entered (x 10<sup>-8</sup>). If using this option, we recommend a value between 1.0 and 1.5, corresponding to the genome-wide average mutation rates reported by recent studies. If the default (0) is kept, the raw relative mutation rates will be returned. When using the scaling feature, by default Mr. Eel will return only the base of each rate (e.g., 1.25, not 1.25e-08). To output rates in scientific notation, simply check the **Output in scientific notation?** box.

### Performance
Mr. Eel takes anywhere from 30 seconds to 15 minutes to run. Since the script reads each chromosome into memory sequentially, speed is primarily determined by the number of unique chromosomes in the input, not the total number of positions (e.g., 10,000 variants on a single chromosome will run faster than 100 variants across all 22 chromosomes). To manage bandwidth, input file size is restricted to 4Mb. If your data exceeds 4Mb, please download the [command line annotation script](/cgi/download.php?dir=assets&file=mr_eel.pl).

### Command line usage
**The command line script is available to [download](/cgi/download.php?dir=assets&file=mr_eel.pl), along with the [7-mer rate table](/cgi/download.php?dir=assets&file=ERV_7bp_rates.txt); the `download_ref.pl` script described below is under construction. When using the command line utility, you _must_ specify the `--rates` and `--ref` options.**
Usage instructions for the command line utility can be viewed with `perl mr_eel.pl --help`.
Note that the download **does not** contain a reference genome. A helper script, `download_ref.pl` is included to download the human_g1k_v37.fasta file used by the web app. If you already have a reference genome on your local machine, you may specify the location with the `--ref /path/to/reference.fasta` argument.

### Help
Feedback, feature requests, and bug reports are welcome! Please refer to the [Github repository](https://github.com/carjed/jedidiahcarlson.com/issues) to review open issues or raise a new one.

### Planned Features
New features will be implemented in the command line script prior to being integrated into the web app. Planned features include:

- Support for VCF and BED files
- Improved validation and error handling
- Optimize memory usage
- Enable additional parameters to be specified on web app (e.g., print sequence, select different K-mer sizes)
- Support for secure uploads
- Plotting output with R Shiny
- and more!

Please see the [development branch](#) (currently pending) of the Mr. Eel repository for the latest experimental release.

### Privacy Policy
We do not require any personally identifiable information in order to use this application. Any data uploaded to our server will be deleted immediately after it is processed. If you have sensitive data, we recommend you download the command line utility, as we cannot guarantee a secure connection to our server at this time.
