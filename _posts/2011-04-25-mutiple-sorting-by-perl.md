---
layout:	post
title:	Mutiple sorting by Perl
tags:	[perl, sort, bowtie, map, bioinformatic]
date:	2011-04-25 15:45:17
---

Here is the code I used to sort the map file produced by bowtie, few modification should work on your files, hope it useful to you.

``` perl
#!/usr/bin/perl -w

# Sort map, also could be used in bed or wig files.
# Contact: Wang Qinhu (qinhu.wang # gmail.com)

use strict;

my @map = ();
my $i = 0;

open (IN, "reads.map") or die "Cannot open file: $!\n";
while (<IN>) {
	chomp;
	my @words = split /\t/, $_;
	my ($id, $num) = split /\_/, $words[0];
	my $strand = $words[1];
	my $scaffold = $words[2];
	my $start = $words[3];
	my $end = $words[3] + length($words[4]);
	my $read = $words[4];
	my ($head, $ord) = split /\_/, $scaffold;
	my $scaffold_num = undef;
	if ($ord < 10 ) {
		$scaffold_num = $head . "_000" . "$ord";
	} elsif ($ord < 100) {
		$scaffold_num = $head . "_00" . "$ord";
	} elsif ($ord < 1000) {
		$scaffold_num = $head . "_0" . "$ord";
	} elsif ($ord < 10000) {
		$scaffold_num = $head . "_" . "$ord";
	} else {
		print "More than 10000 RefSeq found!\n";
		exit;
	}
	$map[$i++] = {	"scaffold" => $scaffold,
	"scaffold_num" => $scaffold_num,
	"strand" => $strand,
	"start" => $start,
	"end" => $end,
	"num" => $num,
	"id" => $id,
	"read" => $read};
}
close IN;

my @sort_map = sort by_map @map;
open (OUT, ">./output/sort.map") or die "Cannot open file: $!\n";
foreach my $map (@sort_map) {
	print OUT $map->{"scaffold"}, "\t", $map->{"strand"}, "\t", $map->{"start"}, "\t";
	print OUT $map->{"end"}, "\t", $map->{"num"}, "\t", $map->{"id"}, "\t",
              $map->{"read"}, "\n";
}
close OUT;

sub by_map {
	$a->{"scaffold_num"} cmp $b->{"scaffold_num"}
	or $a->{"strand"} cmp $b->{"strand"}
	or $a->{"start"} <=> $b->{"start"}
	or $b->{"num"} <=> $a->{"num"}
	or $a->{"end"} <=> $b->{"end"}
}
```

This is a demo

```
wangqinhu@darwin[~] $ cat reads.map
lab0000001_285583	+	scaffold_4	116913	GGCGAGCCCGGCGGAGTCGC
lab0000001_285583	-	scaffold_25	11613	CGTGGGTCAGTGCGACGCGTG
lab0000002_136986	+	scaffold_4	116912	GGCAGCGCGGAAGTCGTGTC
lab0000002_136986	-	scaffold_25	11613	GGTAGCGCGGCGATGCGCG
lab0000003_59405	+	scaffold_4	116911	GGAGCGGGCGACGACGGCGC
lab0000003_59405	-	scaffold_25	11613	GCGTAGTACGTCGTCGTCAGT
lab0000004_42594	+	scaffold_4	116913	GGTGTCAGTACGCGTCGTGTC
lab0000004_42594	-	scaffold_25	11612	GGTCAGTACGTGTACCGTCGTAG
lab0000005_32758	-	scaffold_25	12003	GACGTGTCAGTCGTCGTC
lab0000005_32758	+	scaffold_4	116520	GGTCGTCAGTCGACGTACGTC
wangqinhu@darwin[~] $ perl sortmap.pl
wangqinhu@darwin[~] $ cat sort.map
scaffold_4	+	116520	116541	32758	lab0000005	GGTCGTCAGTCGACGTACGTC
scaffold_4	+	116911	116931	59405	lab0000003	GGAGCGGGCGACGACGGCGC
scaffold_4	+	116912	116932	136986	lab0000002	GGCAGCGCGGAAGTCGTGTC
scaffold_4	+	116913	116933	285583	lab0000001	GGCGAGCCCGGCGGAGTCGC
scaffold_4	+	116913	116934	42594	lab0000004	GGTGTCAGTACGCGTCGTGTC
scaffold_25	-	11612	11635	42594	lab0000004	GGTCAGTACGTGTACCGTCGTAG
scaffold_25	-	11613	11634	285583	lab0000001	CGTGGGTCAGTGCGACGCGTG
scaffold_25	-	11613	11632	136986	lab0000002	GGTAGCGCGGCGATGCGCG
scaffold_25	-	11613	11634	59405	lab0000003	GCGTAGTACGTCGTCGTCAGT
scaffold_25	-	12003	12021	32758	lab0000005	GACGTGTCAGTCGTCGTC
```
