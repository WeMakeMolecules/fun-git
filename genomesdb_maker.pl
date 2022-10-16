#This script will create a GENOMES folder and a GENOMES.IDs file for all the outputs from the annotation pipeline
#The output is ready for the CORASON3 /fungison pipeline
#by Pablo Cruz-Morales October 2022 pcruzm@biosustain.dtu.dk
open OUT, ">genomes_database_naming.sh" or die "I cant write the genomes_database_naming.sh file\n";
open GENOMESFILE, ">GENOMES.IDs" or die "I cant write the GENOMES.IDs file\n";
print "Creating the GENOMES.IDs file\n";
@files=`ls *.faa`;
foreach  (@files){
$cont++;
$genome="$_";
$header=`sed -n 1p $genome`;
$genome=~s/.faa//;
$header=~s/>fig\|//;
$header=~s/.peg.1//;
chomp $header;
chomp $genome;
print GENOMESFILE "$cont\t$header\t$genome\t$cont\n";
print OUT "cp $genome.faa ./GENOMES/$cont.faa\ncp $genome.txt ./GENOMES/$cont.txt\n";
}
print GENOMESFILE "\n";
close OUT;
print "Preparing the GENOMES database\n";
system "mkdir GENOMES";
system "sh genomes_database_naming.sh"

