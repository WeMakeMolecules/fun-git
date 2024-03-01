#!/usr/bin/perl

use strict;
use warnings;
use File::Path qw(make_path);
use File::Copy;
use List::Util qw(shuffle);

# Define the original directory containing 90 directories
my $original_directory = "/media/ynp/mission/YNP_ASSEMBLIES/BGC_online";

# Define the output directory
my $output_directory = "/media/ynp/mission/YNP_ASSEMBLIES/BGC_SAMPLES";

# Define the number of sets to create
my $num_sets = 18; # Assuming each set has increments of five directories, 90/5 = 18


# Retrieve the list of original directories
my @original_directories = glob("$original_directory/*");
my @shuffled_directories = shuffle(@original_directories);

# Create sets
for (my $i = 1; $i <= $num_sets; $i++) {
    my $set_name = "set_$i";
    my $set_directory = "$output_directory/$set_name";
    make_path($set_directory); # Create the directory for the current set

    # Determine the directories to include in this set
    my @selected_directories = @shuffled_directories[($i-1)*5 .. ($i*5)-1]; # Select five directories for this set

    # Copy selected directories and their files to the set directory
    foreach my $dir (@selected_directories) {
        my $dest_dir = "$set_directory/" . (split('/', $dir))[-1];
        make_path($dest_dir); # Create the directory in the set directory

        # Copy the directory and its files to the set directory using `cp` Unix function
        system("cp -r '$dir' '$dest_dir'") == 0 or die "Copy failed: $!";
    }
}



#creating directories with incremental number of genomes
system "cp -r $output_directory/set_1/* $output_directory/set_2/.";
system "cp -r $output_directory/set_2/* $output_directory/set_3/.";
system "cp -r $output_directory/set_3/* $output_directory/set_4/.";
system "cp -r $output_directory/set_4/* $output_directory/set_5/.";
system "cp -r $output_directory/set_5/* $output_directory/set_6/.";
system "cp -r $output_directory/set_6/* $output_directory/set_7/.";
system "cp -r $output_directory/set_7/* $output_directory/set_8/.";
system "cp -r $output_directory/set_8/* $output_directory/set_9/.";
system "cp -r $output_directory/set_9/* $output_directory/set_10/.";
system "cp -r $output_directory/set_10/* $output_directory/set_11/.";
system "cp -r $output_directory/set_11/* $output_directory/set_12/.";
system "cp -r $output_directory/set_12/* $output_directory/set_13/.";
system "cp -r $output_directory/set_13/* $output_directory/set_14/.";
system "cp -r $output_directory/set_14/* $output_directory/set_15/.";
system "cp -r $output_directory/set_15/* $output_directory/set_16/.";
system "cp -r $output_directory/set_16/* $output_directory/set_17/.";
system "cp -r $output_directory/set_17/* $output_directory/set_18/.";



#running bigscape for the different sets
system "run_bigscape  $output_directory/set_1  $output_directory/1 -c 36";
system "run_bigscape  $output_directory/set_2  $output_directory/2 -c 36";
system "run_bigscape  $output_directory/set_3  $output_directory/3 -c 36";
system "run_bigscape  $output_directory/set_4  $output_directory/4 -c 36";
system "run_bigscape  $output_directory/set_5  $output_directory/5 -c 36";
system "run_bigscape  $output_directory/set_6  $output_directory/6 -c 36";
system "run_bigscape  $output_directory/set_7  $output_directory/7 -c 36";
system "run_bigscape  $output_directory/set_8  $output_directory/8 -c 36";
system "run_bigscape  $output_directory/set_9  $output_directory/9 -c 36";
system "run_bigscape  $output_directory/set_10  $output_directory/10 -c 36";
system "run_bigscape  $output_directory/set_11  $output_directory/11 -c 36";
system "run_bigscape  $output_directory/set_12  $output_directory/12 -c 36";
system "run_bigscape  $output_directory/set_13  $output_directory/13 -c 36";
system "run_bigscape  $output_directory/set_14  $output_directory/14 -c 36";
system "run_bigscape  $output_directory/set_15  $output_directory/15 -c 36";
system "run_bigscape  $output_directory/set_16  $output_directory/16 -c 36";
system "run_bigscape  $output_directory/set_17  $output_directory/17 -c 36";
system "run_bigscape  $output_directory/set_18  $output_directory/18 -c 36";
