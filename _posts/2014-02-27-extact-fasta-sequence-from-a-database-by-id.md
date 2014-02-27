---
layout:	post
title:	Extact fasta sequence from a database by id
tags:	[fasta, extract, sequence, id, perl, database, list]
date:   Thu Feb 27 14:47:29 CST 2014
image:
  feature: L77.jpg
---

It is our routine and frequenct work to extract the fasta sequence from a fasta sequence database file with known id list.

Here is a my quick approach, suppose you already have a fasta format database and the id list is given one indentifier per line.

Save the following perl script as getseqbyid.pl and type:

``` bash
perl getseqbyid.pl <id.list> <database.fasta> <output.fasta>
```

in the termnial you will get it.

``` perl
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

