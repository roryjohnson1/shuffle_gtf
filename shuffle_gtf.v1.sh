#!/usr/bin/env bash

# A script that takes a GTF as STDIN, and randomly repositions the locations.

# Genome file for bedTools shuffle
GENOME_FILE="/users/rg/rjohnson/science/DATA.FILES/BedTools.genome.files/hg38.genome"
# Seed for shuffling
SEED=927442959

# Write the input to temporary file
cat - > temp.gtf

# Extract genes from GTF, convert to BED, shuffle
cat temp.gtf | grep -v \# | tr "\t" " " | awk '$3=="gene" {print $1"\t"$4"\t"$5"\t"$0"\t.\t"$7}' | bedtools shuffle -seed $SEED -i - -g $GENOME_FILE > temp.bed

# This creates a file temp2.txt linking the gene ID coordinates between old and shuffled: output= shuffled chr / shuffled first nt / old first nt  strand (strand same in old and shuffled)
cat temp.bed | perl -ne '@line=split();  ($ensg)=$_=~/gene_id \"(.*?)\"/; if($line[5] eq 'gene'){ print "$ensg\t$line[0]\t$line[1]\t$line[6]\t$line[-1]\n"}' | sort > temp2.txt

# The original GTF file with leading gene id column
cat temp.gtf | grep -v \# | tr "\t" " " |tr " " ":"  | perl -ne '@line=split();  ($ensg)=$_=~/gene_id\:\"(.*?)\"/; { print "$ensg\t$_"}' | sort > temp3.txt

# Join the two temp files, recalculate position in GTF using new shuffled coordinates of genes. Should produce correct output format with tab and whitespace delimiters
join -1 1 -2 1 temp2.txt temp3.txt | perl -ne '@line=split ''; @gtfer=split(":",$line[5]); $gtfer[0]=$line[1]; $gtfer[3]=$gtfer[3]-$line[3]+$line[2]; $gtfer[4]=$gtfer[4]-$line[3]+$line[2] ; $gtfer[6]=$line[4]  ; print "@gtfer\n"' | sed 's/ /\t/;s/ /\t/;s/ /\t/;s/ /\t/;s/ /\t/;s/ /\t/;s/ /\t/;s/ /\t/;'

# Clean up
rm temp.gtf
rm temp.bed
rm temp2.txt
rm temp3.txt



