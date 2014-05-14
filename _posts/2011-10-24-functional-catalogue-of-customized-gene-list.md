---
layout:	post
title:	Functional catalogue of customized gene
tags:	[funcat, perl, Arabidopsis, gene funcation, classification, blast]
date:	2011-10-24 23:52:09
---

Functional Catalogue (FunCat) is a hierarchically structured, organism-independent, flexible and scalable controlled classification system enabling the functional description of proteins from any organism [1]. Here is my solution to perform FunCat classification in Arabidopsis. Please note in this Perl script, NCBI BLAST was called and bioperl was used to parse the blast result, we use eight cores of CPU in default to perform this analysis.

``` perl
#!/usr/bin/perl -w
# File Name: FunCat.pl
# Note: FASTA files are expected for input.
# Version 1.00
# Copyright (c) 2008-2010 NWAFU
# Author: Wang Qinhu (qinhu.wang@gmail.com)
# Created on Aug, 2008

use strict;
use Bio::SearchIO;

# System Parameters:
my $query_file = $ARGV[0] || 'query.fa';
my $cpu = $ARGV[1] || '8';

#Format DataBase
system("formatdb -i ATprotein -p T -o T");
#Perform BLAST
system("blastall -p blastx -d ATprotein -i $query_file -e 1e-5 -a $cpu -b 2 -o blast.out");
system("rm ATprotein.p*");
system("rm formatdb.log");
#Read Arabidopsis FunCat Scheme
my $id = "";
my $num = "";
my %list = ();
open (IN,  "athaliana_funcat2008");
while (my $line = <IN>) {
	chomp $line;
	($id, $num) = split(/\|/, $line);
	if (!exists $list{$id}) {
		$list{$id} = $num;
	} else {
		next;
	}
}
close IN;
$list{"NO HITS FOUND"} = "00";

#Parse BLAST, and Assign FunNum
my $in = new Bio::SearchIO(
-format => 'blast',
-file   => 'blast.out');
open (OUT,">BLAST.cat");
my $Gene = "";
my $HitId = "";
my %Cata = ();
while(my $result = $in->next_result) {
	$Gene = $result->query_name;
	while(my $hit = $result->next_hit) {
		$Cata{$Gene} = $hit->name;
		last;
	}
	if (!defined $Cata{$Gene}) {
		$Cata{$Gene} = "No hits found";
	}
	print OUT "$Gene\t";
	print OUT "$Cata{$Gene}\t";
	$Cata{$Gene} =~ tr/[a-z]/[A-Z]/;
	if (!exists $list{$Cata{$Gene}}) {
		$list{$Cata{$Gene}} = "-1";
	}
	print OUT $list{$Cata{$Gene}}, "\n";
}
close(OUT);

#Output Cat
my %dna = ();
my %log = ();
my $logdat = undef;
open (IN, "BLAST.cat");
while (my $line = <IN>) {
	chomp $line;
	my ($gene, $hit, $cata) = split /\t/, $line;
	my $infor = $gene . "\t" . $hit;
	$dna{$infor} = $cata;
}
close IN;
open (OUT, ">Clean.cat");
foreach my $infor (sort By_CatNum keys %dna) {
	print OUT $dna{$infor}, "\t", $infor, "\n";
	$logdat = $dna{$infor};
	$logdat = substr($logdat, 0, 2);
	$log{$logdat}++;
}
close OUT;
open (CAT, ">FunCat.dat");
print CAT "Cata\tNum\n";
foreach my $logdat (sort keys %log) {
	print CAT $logdat, "\t", $log{$logdat}, "\n";
}
close CAT;
sub By_CatNum { $dna{$a} <=> $dna{$b} }
```

Reference:  
1. Ruepp, A. *et al.* (2004) The FunCat, a functional annotation scheme for systematic classification of proteins from whole genomes. ***Nucleic Acids Res***. 32:5539-5545.
