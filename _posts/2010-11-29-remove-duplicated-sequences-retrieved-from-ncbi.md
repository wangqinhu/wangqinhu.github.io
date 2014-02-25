---
layout:	post
title:	Remove duplicated sequences from NCBI
tags:	[ncbi, bioinformatic, perl, remove duplication, sequence]
date:	2010-11-29 12:43:22
image:
  feature: L77.jpg
---

We usually download sequences from NCBI by one entrez retrieve, but for more than one retrieves, we may get some duplicated sequences, in this case, we often need to remove the duplicated sequences and get a unique sequences set. Here I supply a simple perl script to do this. Please make sure that your sequences with the same ids have the same sequences contents; otherwise this script is not suitable for you.

``` perl
#!/usr/bin/perl -w
# Remove the duplicated sequences downloaded from NCBI.

use strict;

my $id = undef;
my %seq = ();

open (IN, "ncbi.fa") or die "Cannot open file: $!\n";
while () {
	chomp;
	if (/^\>/) {
		my @head = split /\|/, $_;
		$id = $head[3];
		if (exists $seq{$id}) {
			$seq{$id} = '';
		}
	} else {
		$seq{$id} .= $_;
	}
}
close IN;

open (OUT, ">uniseq.fa");
foreach (sort keys %seq) {
	print OUT ">", $_, "\n";
	print OUT $seq{$_}, "\n";
}
close OUT;
```

Note: Your input/output sequences format is FASTA.
