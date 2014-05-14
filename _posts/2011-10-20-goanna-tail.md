---
layout:	post
title:	GoAnna tail
tags:	[GO, annotation, gene ontology, GoAnna, perl, slim, term, bioinformatic, blast]
date:	2011-10-11 01:24:09
---

This script was wrote three years ago, now I decide to share the script and hope this could inspire the one who want to perform Gene Ontology (GO) annotation themselves, not by the ready-to-use applications.

``` perl
#!/usr/bin/perl
# A perl script to handle the result of GoAnna, which is used for Geneontology
# Annotation, and it is available at:
# http://www.agbase.msstate.edu/GOAnna.html
# This scrit should be feeded by the output of GoAnna (the *.xls file only),
# and it generates human readable and computer minable go annotation, also goslims
# results.
#
# File Name: GoAnna_tail_delta.pl
# Version 1.03
# Copyright (c) 2009-2010 by NWAFU
# Author: Wang Qinhu (wangqinhu@nwafu.edu.cn)
# Last Modified: Aug 9, 2009
# Additional files:
# goaslim.map is available at:
#	ftp://ftp.ebi.ac.uk/pub/databases/GO/goa/goslim/goaslim.map
# goslim_goa.go is available at:
#	ftp://ftp.geneontology.org/pub/go/GO_slims/goslim_goa.go


use strict;

my $in = $ARGV[0] || "GoAnno.sprot.out";
my $table = $ARGV[1] || "GOA.Table";
my $goa = $ARGV[2] || "GOA";

open (IN, "$in") or die "Cannot open file $in: $!\n";
open (TMP, ">Temp.table") or die "Cannot create file Temp.table: $!\n";

my $seq_id = undef;
my $id_counter = 0;
my @seq_id = ();
my @feilds = ();
my %blastx_hit = ();
my %blastx_pro = ();
my %blastx_exp = ();

print TMP "#UniGene_Id\tGO_Id\tOntology\tGO_Term\n";

# Create Table.
while (my $line = <IN>) {
	chomp $line;
	if ( $line =~ /Input/) {
		next;
	} elsif ($line =~ /Database/) {
		next;
	} elsif ($line =~ /^=[\D\d]+\>([\D\d]+)\"/) {
		$seq_id = $1;
		$seq_id[$id_counter] = $seq_id;
		$id_counter++;
	} else {
		@feilds = split /\t/, $line;
		#To get the size of this array.
		my $feilds = @feilds; 
		#print $feilds, "\n";
		if ($feilds == 5) {
			$blastx_hit{$seq_id} = $feilds[1];
			$blastx_pro{$seq_id} = $feilds[2];
			$blastx_exp{$seq_id} = $feilds[4];
		} elsif ($feilds == 18) {
			if ($blastx_exp{$seq_id} <= 1e-5) {
				print TMP $seq_id, "\t";
				print TMP  $feilds[6], "\t", $feilds[10], "\t", $feilds[11], "\n";
			}
		} else {
			next;
		}
	}
}

close TMP;
close IN;

# Remove Redundant Record.
open (TAB, "Temp.table") or die "Cannot open file Temp.table: $!\n";
open (RRR, ">$table.nr") or die "Cannot create file $table.nr: $!\n";

my @table = ();
my $i = 0;
while (my $line = <TAB>) {
	#Load Table.
	$table[$i] = $line;
	$i++;
}
my @table_nr = ();
my %control = ();
foreach (@table) {
	# Use Hash to Remove Redundance.
	if (!$control{$_}) {
        push (@table_nr, $_);
    }
    $control{$_}++;
}

# Output Temp.table (or Table.alpha). 
print RRR "@table_nr\n";

close RRR;
close TAB;

open (NR, "$table.nr") or die "Cannot open file $table.nr: $!\n";

my $g_index = undef;
my %goa_dict = ();
my %goa = ();
while (my $line = <NR>) {
	if ($line =~ /^#/) {
		next;
	} elsif ($line =~ /\S+/) {
		my @element = split /\t/, $line;
		$g_index = $element[1];
		$goa_dict{$g_index} = $element[2] . "\t" . $element[3];
		$goa{$g_index} .= $element[0] . "\n";
	} else {
		next;
	}
}

close NR;

# split into different ontologies.
open (NR, "$table.nr") or die "Cannot open file $table.nr: $!\n";
open (F, ">$table.F") or die "Cannot create file $table.F: $!\n";
open (P, ">$table.P") or die "Cannot create file $table.P: $!\n";
open (C, ">$table.C") or die "Cannot create file $table.C: $!\n";
print F "#UniGene_Id\tGO_Id\tOntology\tGO_Term\n";
print P "#UniGene_Id\tGO_Id\tOntology\tGO_Term\n";
print C "#UniGene_Id\tGO_Id\tOntology\tGO_Term\n";

while (my $line = <NR>) {
	if ($line =~ /^\#/) {
		next;
	} 
	if ($line =~ /^\s*$/) {
		next;
	}
	my @words = split /\t/, $line;
	if (length($words[2]) != 1) {
		print $words[2], "\n";
	}
	my $ontology = $words[2];
	if ($ontology eq "F") {
		print F $line;
	} elsif ($ontology eq "P") {
		print P $line;
	} elsif ($ontology eq "C") {
		print C $line;
	} else {
		next;
	}
}

close NR;
close F;
close P;
close C;

# Assign unigene to goa
open (GOA, ">$goa") or die "Cannot create file $goa: $!\n";

foreach (keys %goa) {
	print GOA $_, "\t", $goa_dict{$_}, $goa{$_};
}

close GOA;

open (GOA, "$goa") or die "Cannot open file $goa: $!\n";
open (F, ">$goa.F") or die "Cannot create file $goa.F: $!\n";
open (P, ">$goa.P") or die "Cannot create file $goa.P: $!\n";
open (C, ">$goa.C") or die "Cannot create file $goa.C: $!\n";


my $go = undef;
my %goterm = ();
my %onto = ();
my %freq = ();

while (my $line = <GOA>) {
	chomp $line;
	if ($line =~ /^#/) {
		next;
	} elsif ($line =~ /^GO/) {
		my @header = split /\t/, $line;
		$go = $header[0];
		$onto{$go} = $header[1];
		$goterm{$go} = $header[2];
		$freq{$go} = 0;
	} elsif ($line =~ /^\s\S+/) {
		$freq{$go}++;
	} else {
		next;
	}
}

foreach my $go (keys %onto) {
	if ($onto{$go} eq "F") {
		print F $go, "\t", $freq{$go}, "\t", $goterm{$go}, "\n";
	} elsif ($onto{$go} eq "P") {
		print P $go, "\t", $freq{$go}, "\t", $goterm{$go}, "\n";
	} elsif ($onto{$go} eq "C") {
		print C $go, "\t", $freq{$go}, "\t", $goterm{$go}, "\n";
	} else {
		print "Opps!\n";
	}
}

close F;
close P;
close C;
close GOA;

#################################################################
# Parse Goaslim.Map
#################################################################

open (MAP, "goaslim.map") or die "Cannot open file GOA.F: $!\n";

my %map_ori = ();
my $go_id = undef;

while (my $line = <MAP>) {
	chomp $line;
	if ($line =~ /^!/) {
		next;
	} elsif ($line =~ /^\s*$/) {
		next;
	} else {
		my @map = split /\t/, $line;
		#Updated v1.02
		unless ($map[0] eq $map[1]) {
			$go_id = $map[0];
			$map_ori{$go_id} = $map[1];
		}
	}
}

close MAP;

# Remap the lower gomap which its higher gomaps has a super-higher gomap.
# Updated at v_1.02
my %map = ();
foreach (keys %map_ori) {
	if (exists $map_ori{$map_ori{$_}}) {
		$map{$_} = $map_ori{$map_ori{$_}};
	} else {
		$map{$_} = $map_ori{$_};
	}

}

#################################################################
# Parsing Goslim_goa
#################################################################
open (GO, "goslim_goa.go") or die "Cannot open file goslim_generic.go: $!\n";
open (GOB, ">goslim.brief") or die "Cannot create file goslim.brief: $!\n";

my $gi = undef;
my %on = ();

while (my $line = <GO>) {
	if ($line =~ /^!/) {
		next;
	} elsif ($line =~ /^$/) {
		next;
	} elsif ($line =~ /^\s*$/) {
		next;
	} elsif ($line =~ /^\s%(\S+)\s;/) {
		print GOB $1, "\n";
	} elsif ($line =~ /^\s{2,4}[%<]([a-z\s\\,]+)\s;\s(GO:[\d]+)/) {
		$gi = $2;
		$on{$gi} = $1;
		$on{$gi} =~ s/\\//g;
		print GOB $gi, "\t", $on{$gi}, "\n";
	} else {
		next;
	}
}
$on{"GO:OMF"} = "other molecular function";
$on{"GO:OBP"} = "other biological processes";
$on{"GO:OCC"} = "other cellular components";
close GOB;
close GO;
#################################################################

open (SLIM, ">Goslim.xls") or die "Cannot create file Goslim.xls: $!\n";
open (LOG, ">Nomap.log") or die "Cannot create file Nomap.log: $!\n";
#################################################################
# Molecular Function
#################################################################
open (GOAF, "GOA.F") or die "Cannot open file GOA.F: $!\n";
print LOG "GOA.F.Nomap\n";
print LOG "*" x 25, "\n";
my %slimf_num = ();
while (my $line = <GOAF>) {
	chomp $line;
	if ($line =~ /^\s*$/) {
		next;
	} elsif ($line =~ /GO:/) {
		my @slim_child =  split /\t/, $line;
		if (exists $map{$slim_child[0]}) {
			$slimf_num{$map{$slim_child[0]}} += $slim_child[1];
		} else {
			print LOG $slim_child[0], "\n";
			$slimf_num{"GO:OMF"} += $slim_child[1];
		}
	} else {
		next;
	}
}
close GOAF;
print SLIM "Molecular Function\n";
foreach (sort {$slimf_num{$a} <=> $slimf_num{$b}} keys %slimf_num) {
	print SLIM "$_\t$on{$_}\t$slimf_num{$_}\n";
}

#################################################################
# Biological Processes
#################################################################
open (GOAP, "GOA.P") or die "Cannot open file GOA.P: $!\n";
print LOG "\n\nGOA.P.Nomap\n";
print LOG "*" x 25, "\n";
my %slimp_num = ();
while (my $line = <GOAP>) {
	chomp $line;
	if ($line =~ /^\s*$/) {
		next;
	} elsif ($line =~ /GO:/) {
		my @slim_child =  split /\t/, $line;
		if (exists $map{$slim_child[0]}) {
			$slimp_num{$map{$slim_child[0]}} += $slim_child[1];
		} else {
			print LOG $slim_child[0], "\n";
			$slimp_num{"GO:OBP"} += $slim_child[1];
		}
	} else {
		next;
	}
}
close GOAP;
print SLIM "\n\nBiological Processes\n";
foreach (sort {$slimp_num{$a} <=> $slimp_num{$b}} keys %slimp_num) {
		print SLIM "$_\t$on{$_}\t$slimp_num{$_}\n";
}

#################################################################
# Cellular Components
#################################################################
open (GOAC, "GOA.C") or die "Cannot open file GOA.C: $!\n";
print LOG "\n\nGOA.C.Nomap\n";
print LOG "*" x 25, "\n";
my %slimc_num = ();
while (my $line = <GOAC>) {
	chomp $line;
	if ($line =~ /^\s*$/) {
		next;
	} elsif ($line =~ /GO:/) {
		my @slim_child =  split /\t/, $line;
		if (exists $map{$slim_child[0]}) {
			$slimc_num{$map{$slim_child[0]}} += $slim_child[1];
		} else {
			print LOG $slim_child[0], "\n";
			$slimc_num{"GO:OCC"} += $slim_child[1];
		}
	} else {
		next;
	}
}
close GOAF;
print SLIM "\n\nCellular Components\n";
foreach (sort {$slimc_num{$a} <=> $slimc_num{$b}} keys %slimc_num) {
	print SLIM "$_\t$on{$_}\t$slimc_num{$_}\n";
}

close LOG;
close SLIM;

# List the unigenes of each goslim.
# This function is added in v1.03
# Particular for biological processes.
open (BP, "$table.P") or die "Cannot open file $table.P: $!\n";
open (BPL, ">$table.P.list") or die "Cannot open file $table.P.list: $!\n";
my %bpl = ();
my $i = 0;
while (my $line = <BP>) {
	if ($line =~ /^#/) {
		next;
	} elsif ($line =~ /\S+/) {
		my ($unigene, $goid, $ontology, $goterm) = split /\t/, $line;
		if (exists $on{$map{$goid}}) {
			$bpl{$i} = "$on{$map{$goid}}\t$unigene\t$goid\t$goterm";
			$i++;
		}
	} else {
		next;
	}
}
foreach (sort values %bpl) {
	print BPL $_;
}
close BP;
close BPL;
# 

__END__
```
