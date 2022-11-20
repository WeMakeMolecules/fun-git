NAME=$1
SAMPLE=$2
#Creating folder for the assembly
mkdir $NAME\_$SAMPLE
#moving the reads for each assembly into the folder:
mv ./Sample$SAMPLE\_R*/*.gz $NAME\_$SAMPLE/
#decompress the reads
gunzip ./$NAME\_$SAMPLE/*.gz
#concatenate all the reads 1 and 2 in a single file, the order is set automatically so dont worry about it
cat ./$NAME\_$SAMPLE/*R1_001.fastq > ./$NAME\_$SAMPLE/$SAMPLE\_raw1.fastq
cat ./$NAME\_$SAMPLE/*R2_001.fastq > ./$NAME\_$SAMPLE/$SAMPLE\_raw2.fastq
#trimm the concatenared reads
TrimmomaticPE -threads 36 ./$NAME\_$SAMPLE/$SAMPLE\_raw1.fastq ./$NAME\_$SAMPLE/$SAMPLE\_raw2.fastq ./$NAME\_$SAMPLE/$SAMPLE\_1P.fastq ./$NAME\_$SAMPLE/$SAMPLE\_1U.fastq ./$NAME\_$SAMPLE/$SAMPLE\_2P.fastq ./$NAME\_$SAMPLE/$SAMPLE\_2U.fastq LEADING:30 TRAILING:30 MINLEN:100
#assembly 
spades -1 ./$NAME\_$SAMPLE/$SAMPLE\_1P.fastq -2 ./$NAME\_$SAMPLE/$SAMPLE\_2P.fastq --cov-cutoff 20 --careful -o ./$NAME\_$SAMPLE/$SAMPLE
# filtering out small contigs (less than 1000 bp) 
awk -v n=1000 '/^>/{ if(l>n) print b; b=$0;l=0;next }{l+=length;b=b ORS $0}END{if(l>n) print b }' ./$NAME\_$SAMPLE/$SAMPLE/scaffolds.fasta > ./$NAME\_$SAMPLE/$NAME\_$SAMPLE.fna
#gene calling using the Trichoderma atroviridae annotation as reference 
augustus --species=Trichoderma_atroviridae  ./$NAME\_$SAMPLE/$NAME\_$SAMPLE.fna --gff3=on --stopCodonExcludedFromCDS=off  > ./$NAME\_$SAMPLE/$NAME\_$SAMPLE.gff
#annotating with antismash
run_antismash ./$NAME\_$SAMPLE/$NAME\_$SAMPLE.fna ./$NAME\_$SAMPLE/annotation --genefinding-gff3 /input/$NAME\_$SAMPLE.gff --taxon fungi --cc-mibig --cb-knownclusters
#creating the fungison formatted files
perl GFF_GBK_to_FUNGISON_2.pl ./$NAME\_$SAMPLE/$NAME\_$SAMPLE.gff ./$NAME\_$SAMPLE/annotation/$NAME\_$SAMPLE/$NAME\_$SAMPLE.gbk
#cleaning
uniq ./$NAME\_$SAMPLE/$NAME\_$SAMPLE.txt          > ./$NAME\_$SAMPLE/$NAME\_$SAMPLE.filtered.txt
rm   ./$NAME\_$SAMPLE/$NAME\_$SAMPLE.txt
mv   ./$NAME\_$SAMPLE/$NAME\_$SAMPLE.filtered.txt  ./$NAME\_$SAMPLE/$NAME\_$SAMPLE.txt

rm -r ./Sample$SAMPLE\_R*
rm -r ./$NAME\_$SAMPLE/$SAMPLE
rm -r ./$NAME\_$SAMPLE/*001.fastq
rm -r ./$NAME\_$SAMPLE/*raw*.fastq
rm -r ./$NAME\_$SAMPLE/*U.fastq

#reporting some metrics
echo "GENOME\tLENGHT\tCONTIGS\tG+C\tN50"
perl GENOME_STATS.pl ./$NAME\_$SAMPLE/$NAME\_$SAMPLE.fna
echo "PROTEINS:"
grep ">" ./$NAME\_$SAMPLE/$NAME\_$SAMPLE.faa -c
echo "BGCs:"
ls ./$NAME\_$SAMPLE/annotation/$NAME\_$SAMPLE/*.region*.gbk |grep $ -c


