---
layout:	post
title:	Split large HMM file to individual HMM files
tags:	[HMM, perl, split, file]
date:   Sun Apr 13 22:19:08 CST 2014
---

Here is a quick script for splilt a single large HMM file into small HMM file individuals, write for Qingdong just now.

``` perl
#!/usr/bin/perl -w

use strict;

$/ = "\/\/\n";

open (IN, $ARGV[0]) or die $!;
my @hmm = <IN>;
close IN;

foreach my $hmm (@hmm) {
	my @w = split /\n/, $hmm, 3 ;
	$w[1]  =~ /\S+\s+(\S+)/;
	open (OUT, ">$1");
	print OUT $hmm;
	close OUT;
}
```
