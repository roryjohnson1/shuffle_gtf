# shuffle_gtf
Randomly shuffles the locations of genes in a GTF annotation, maintaining relative positions of exons and transcripts.
Input is STDIN, output is STDOUT.
Important1: Need to specify the BEDTools "Genome File" within the script, being the lengths of each chromosome in the assembly you're using:
chr1    197195432
chr2    181748087
chr3    159599783
chr4    155630120
chr5    152537259...
Important2: Script requires BEDTools to be installed.
