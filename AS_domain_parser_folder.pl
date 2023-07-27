##################################################################################
# AS_domain_parser_folder.pl
# by Pablo Cruz-Morales July 27 20213
# A simple parser to extract all the antismash7 annotated files in a cute table 
#	works in fungal and bacterial genomes
# place it into the folder with folders of antismash 7 outputs and obtain a table 
# use: perl AS_domain_parser_folder.pl 
# output goes into the STDOUT
# output structure: 
# Folder name locus_tag region_product  AA_seq Domain monomers
# VIVA LA PERL!!!
###################################################################################
@folders=`ls -d */`;
foreach(@folders){
	chomp $_;
	$foldername="$_";
	$foldername=~s/\///;
	@files=`ls \.\/$_\*region\*.gbk`;
	foreach(@files){
	@domainstring=();
	@regionarray=();
	open FILE, $_ or die "give me an input\n";
	while ($line=<FILE>){
		if ($line=~/     CDS             /.. $line=~/                     \/gene\=/){
		$flag=1;
		#printing the domains from the last loop
			if (scalar @domainarray > 0){
				#reversing and printing the domainarray for genes in minus strand
				if ($orientation=~/minus/){
				@reverse_domains= reverse @domainarray;	
				$domainstring = join( '-', @reverse_domains);
				@domainarray=();
				@reverse_domains=();
				print "\t$domainstring";
				}
				#printing the domainarray for genes in plus strand
				if ($orientation=~/plus/) {
				$domainstring = join( '-', @domainarray );
				@domainarray=();
				print "\t$domainstring";
				}
			}
			if (scalar @extenderarray > 0){
				$extenderstring = join( '-', @extenderarray );
				@extenderarray=();
				print "\t$extenderstring";
			}
			#gets locus tags
			if ($line=~/CDS             complement/){
				}
			if ($line=~/\/gene\=/){
				$locus="$line";
				$locus=~s/\s+\/gene="//;
				$locus=~s/"//;
				chomp $locus;
				if ($flag==1){
					print "\n$foldername\t$locus\t$regionnumber\_$product\t";
				}
			}
		}#end of gene to CDS
		#gets proteins
		if($line=~/                     \/translation\=\"[ARNDCEQGHILKMFPSTWYV]+/ or $line=~m/^                     [A-Z \W]+$/ or $line=~/                     \/translation\=\"[ARNDCEQGHILKMFPSTWYV]+\"/){
			$sequence="$line";
			$sequence=~s/\s+//g;
			$sequence=~s/\/translation\=\"//;
			$sequence=~s/\"//;
			chomp $sequence;
			if ($sequence=~/\"/){
				$sequence="";
			}
			if ($flag==1){
				print "$sequence";
			}
		}#end of proteins
		#gets SMILES and gets them out of the way 
		if ($line=~/     cand\_cluster   /.. $line=~/\/tool\=\"antismash\"\n     region          /){
			if ($line=~/\/SMILES\=/){
			$smile="$line";
			$smile=~s/\s+\/SMILES\=\"//;
			$smile=~s/"//;
			$smile=~s/A-OX\)\)//;
			chomp $smile;
			#print "$smile\n";
			}
		}#smiles	
		#get pfam domains and keep them away 
		if ($line=~/     PFAM_domain     /..$line=~/                     \/tool\=\"antismash\"/){ 
			$flag=0;
		}#pfam  
		#get asdomains and specificity	
		if ($line=~/     aSDomain        /..$line=~/                     \/tool\=\"antismash\"/){ 
		$flag=0;
			#recording reverse gene direction to correct the domainstring		
			if ($line=~/     aSDomain        complement/){
				$orientation="minus";
				}
			#recording natural gene direction to keep the domainstring as is
			if ($line=~/     aSDomain        \d+/){
				$orientation="plus";
				}
			if ($line=~/                     \/aSDomain\=\"/){
				$asdomain="$line";			
				$asdomain=~s/\/aSDomain\=\"//;
				$asdomain=~s/\"//;
				$asdomain=~s/\s+//;
				$asdomain=~s/PKS_Docking_Cterm/Dock_C/;
				$asdomain=~s/PKS_Docking_Nterm/Dock_N/;
				$asdomain=~s/PKS_//;
				$asdomain=~s/Thioesterase/Te/;
				$asdomain=~s/NAD_binding_4/Red/;
				$asdomain=~s/TD/Red/;
				$asdomain=~s/PCP/xCP/;
				$asdomain=~s/ACP/xCP/;
				$asdomain=~s/PP-binding/xCP/;
				$asdomain=~s/PP/xCP/;
				$asdomain=~s/Aminotran_./Atg/;
				$asdomain=~s/Condensation/C/;
				$asdomain=~s/AMP-binding/A/;
				$asdomain=~s/Epimerization/E/;
				chomp $asdomain;
				push(@domainarray, $asdomain);
			}
			if ($line=~/\/specificity\=\"consensus\:/){
				$extender="$line";
				$extender=~s/\/specificity\=\"consensus\://;
				$extender=~s/\"//;
				$extender=~s/\s+//g;		
				chomp $extender;
				push(@extenderarray, $extender);
			}
		}#from ASdomains
		if ($line=~/     region          /..$line=~/                     \/region\_number\=\"/){ 
			if ($line=~/\/product\=\"/g){
				$regionproduct="$line";
				$regionproduct=~s/\/product\=\"//;
				$regionproduct=~s/\"//;
				$regionproduct=~s/\s+//g;		
				push(@regionarray, $regionproduct);
				$product = join( '-', @regionarray );
			}
			if ($line=~/\/region\_number\=\"/g){
				$regionnumber="$line";
				$regionnumber=~s/\/region\_number\=\"//;
				$regionnumber=~s/\"//;
				$regionnumber=~s/\s+//g;		
				chomp $regionnumber;
			}
		}#region
	}#from while	
	}#close penultimate loop, files
}#close first loop, folder
close;
