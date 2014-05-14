---
layout:	post
title:	Extract the sequences having significant BLAST hits
tags:	[blast, perl, bioinformatic, fasta, extract, hits]
date:	2010-08-30 19:28:32
---

To perform sequences similarity search, we usually use NCBI BLAST. However, we often need to parse the result to split the sequences which have significant and/or insignificant hits, respectively. Here is the sample to do this work via bioperl, I hope it will supply useful information to you. Thank you!

``` perl
#!/usr/bin/perl -w

use strict;
use Bio::SearchIO;

my $query = "";
my $SeqId = undef;
my %hit = ();
my %Seq = ();
my %Des = ();

open (SEQ, "seq.fasta");
while (my $line = <SEQ>) {
	if ($line =~ /^>(\S+)\s*.*$/) {
		$SeqId = $1;
		$Des{$SeqId} = $line;
	} else {
		$Seq{$SeqId} .= $line;
	}
}
close SEQ;

open (NO, ">nohits.fasta");
open (HIT, ">hits.fasta");

my $in = new Bio::SearchIO(
-format => 'blast',
-file => 'blast.txt');

while(my $result = $in->next_result) {

	$query = $result->query_name;

	while (my $hit = $result->next_hit) {
		$hit{$query} = $hit->name;
	}

	if (!defined $hit{$query}) {
		print NO $Des{$query};
		print NO $Seq{$query};
	} else {
		print HIT $Des{$query};
		print HIT $Seq{$query};
	}

}

close NO;
close HIT;
```
