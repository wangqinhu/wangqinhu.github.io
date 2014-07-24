---
layout:	post
title:	Remove duplicated sequences by hash
tags:	[perl, hash, remove duplication, sequence, fasta]
date:   Thu Jul 24 21:04:34 CST 2014
---

Previously, I had give an example [how to remove duplicated sequence have the same id][1].

Today Xiwang ask me how to remove duplicated sequences, and I wirte this script for him.

Say you have fasta sequence, named "demo.fa", like this:


	>seq1
	gtcatactactactactcgtgactgtacgtac
	catgtactgca
	gtcatgacgtac
	>seq2
	gtcatactactactactcgtgactgtacgtac
	catgtactgca
	gtcatgacgtac
	>seq3
	gtcatactactactactcgtgactgtacgtac
	catgtactgca
	gtcatgacgtac
	>seq4
	gtaccacactactactactttgcatgttcgtgactgtacgtac
	catgcactgcacattgcgtcatg
	gtcaagacgtaccgtacgtcagt


seq1, seq2 and seq3 are duplicated sequences. The basic principle is that [the key of each hash element is unique][2], again.

First, read the fasta sequences regularly, id as hash key, seq as hash value. And then swap them, :), done.

``` perl
#!/usr/bin/env perl

use warnings;

my $seqfile = $ARGV[0] || "demo.fa";
my $outfile = $ARGV[1] || "unique.fa";

# read fasta seq
my %seq = ();
my $id = undef;
open (FASTA, $seqfile) or die "Cannot open file $seqfile: $!\n";
while (my $line = <FASTA>) {
	chomp $line;
	if ($line =~ /^\>(\S+)/) {
		$id = $1;
	} else {
		$line =~ s/\s//g;
		$line =~ s/\d//g;
		$seq{$id} .= uc($line);
	}
}
close FASTA;

# swap: id <=> seq
my %swap = ();
foreach my $key (sort keys %seq) {
	$swap{$seq{$key}} .= "$key\t";
}

# output
open (UNI, ">$outfile") or die "Cannot open file $outfile: $!\n";
foreach my $seq (keys %swap) {
	print UNI ">$swap{$seq}\n";
	print UNI $seq, "\n";
}
close UNI;
```

After running this script, you will get the following unique sequnces (defalut file name: "unique.fa"):

	>seq4
	GTACCACACTACTACTACTTTGCATGTTCGTGACTGTACGTACCATGCACTGCACATTGCGTCATGGTCAAGACGTACCGTACGTCAGT
	>seq1	seq2	seq3
	GTCATACTACTACTACTCGTGACTGTACGTACCATGTACTGCAGTCATGACGTAC

[1]: /remove-duplicated-sequences-retrieved-from-ncbi/
[2]: /use-hash-to-remove-redundance-of-a-table/
