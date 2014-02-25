#!/usr/bin/perl -w
# Filename: map2bedwig.pl
# Convert bowtie map file into *.bed and *.wig file
# Note: reads are in fasta format as follow:
# >seqid1_x56
# CAGATCGATCGATCGAGCGCGACT
# >seqid2_x48
# GTCGATGAGCGACCGCGCGCGCGG
# Here 56 and 48 after x are the reads numbers.
# qinhu.wang (at) gmail.com


use strict;

my $usage = "
  Usage: $0 <MAP> <SEP>
  MAP: bowtie map file without --suppress
  SEP: ID Seperator of reads_id and reads_num\n";
 
print $usage;

my $map = $ARGV[0] || "bowtie.map";
my $sep = $ARGV[1] || "_x";

open (MAP, $map) or die "Cannot open file $map: $!\n";
open (BED, ">map.bed") or die "Cannot create file map.bed: $!\n";
open (WIG, ">map.wig") or die "Cannot create file map.wig: $!\n";
while (<MAP>) {
	my ($index, $strand, $refseqid, $start, $read, $discard) = split /\t/, $_, 6;
	my ($idx, $num) = split /$sep/, $index;
	my $end = $start + length($read);
	print BED $refseqid . "\t" . $start . "\t" . $end . "\t" . $strand;
	print WIG $refseqid . "\t" . $start . "\t" . $end . "\t" . $num;
}
close MAP;
close BED;
close WIG;

__END__
