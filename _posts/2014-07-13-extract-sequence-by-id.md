---
layout:	post
title:	Extract sequence by identifier
tags:	[fasta, perl, sequence, bioinformatic]
date:   Sun Jul 13 22:32:43 CST 2014
---

A quick perl script used for extracting a subset of a total fasta sequence data, you need two files: (1) the full set of fasta sequences; (2) the id or name of the subset sequence you would like to retrieve, one item per line please.

```perl

#!/usr/bin/perl -w

use strict;

my $list = $ARGV[0] || 'ID.txt';
my $data = $ARGV[1] || 'DB.fas';
my $outs = $ARGV[2] || 'SQ.fas';


my @list = ();
open (LIST,$list) or die "Cannot open file $list: $!\n";
while (my $id = <LIST>) {
	chomp $id;
	$id =~ s/\s//g;
 	push @list, $id
}
close LIST;

my %seq = ();
my $sid = ();
open (IN, $data) or die "Cannot open file $data: $!\n";;
while (<IN>) {
	if (/^\>(\S+)/) {
		$sid = $1;
		my @w = split /\|/, $sid;
		if (@w > 2) {
			$sid = $w[2];	
		} else {
			$sid = $w[0];
		}
	} else {
		$seq{$sid} .= $_;
	}
}
close IN;


open (OUT, ">$outs") or die "Cannot create file $outs: $!\n";
foreach my $id (@list) {
	print OUT ">$id\n";
	print OUT $seq{"$id"};
}
close OUT;
```
