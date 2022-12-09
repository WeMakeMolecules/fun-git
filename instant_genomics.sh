NAME=$1
#Creating folder for the assembly
#mkdir $NAME
#moving the reads for each assembly into the folder:
#mv $NAME\_R*.gz $NAME/

#trimm the concatenared reads
#TrimmomaticPE -threads 36 ./$NAME/$NAME\_R1_001.fastq.gz ./$NAME/$NAME\_R2_001.fastq.gz ./$NAME/$NAME\_1P.fastq ./$NAME/$NAME\_1U.fastq ./$NAME/$NAME\_2P.fastq ./$NAME/$NAME\_2U.fastq LEADING:30 #TRAILING:30 MINLEN:120
#assembly 
#spades -1 ./$NAME/$NAME\_1P.fastq -2 ./$NAME/$NAME\_2P.fastq  --careful --cov-cutoff 100 -o ./$NAME/$NAME
# filtering out small contigs (less than 1000 bp) 
#awk -v n=1000 '/^>/{ if(l>n) print b; b=$0;l=0;next }{l+=length;b=b ORS $0}END{if(l>n) print b }' ./$NAME/$NAME/scaffolds.fasta > ./$NAME/$NAME.fna
#gene calling using the Trichoderma atroviridae annotation as reference 
#augustus --species=aspergillus_oryzae  ./$NAME/$NAME.fna --gff3=on --stopCodonExcludedFromCDS=off  > ./$NAME/$NAME.gff
#annotating with antismash
#run_antismash ./$NAME/$NAME.fna ./$NAME/annotation --genefinding-gff3 /input/$NAME.gff --taxon fungi --fullhmmer --cc-mibig --cb-knownclusters
#creating the fungison formatted files
perl GFF_GBK_to_FUNGISON_3.pl ./$NAME/$NAME.gff ./$NAME/annotation/$NAME/$NAME.gbk
#cleaning
rm -r ./Sample$SAMPLE\_R*
rm -r ./$NAME\_$SAMPLE/$SAMPLE
rm -r ./$NAME\_$SAMPLE/*001.fastq
rm -r ./$NAME\_$SAMPLE/*raw*.fastq
rm -r ./$NAME\_$SAMPLE/*U.fastq

#reporting some metrics
echo "GENOME\tLENGHT\tCONTIGS\tG+C\tN50"
perl GENOME_STATS.pl ./$NAME/$NAME.fna
echo "PROTEINS:"
grep ">" ./$NAME/$NAME.faa -c
echo "BGCs:"
ls ./$NAME/annotation/$NAME/*.region*.gbk |grep $ -c

