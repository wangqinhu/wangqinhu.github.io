---
layout:	post
title:	Use hash to remove redundance of a table
tags:	[bioinformatic, perl, redundance, table, hash]
date:	2010-07-01 11:26:41
---

In some of our daily bioinformatics works, we need to remove the redundancy of a table. Of course you can do this by the system command `sort` (in UNIX/Linux). Here we use Perl to do this, the basic principle is that ___the key of each hash element is unique___.

``` perl
#!/usr/bin/perl -w

use strict;

# create a table with redundant
open (TAB, ">data.table") or die "Cannot open file data.table: $!\n";

print TAB "1 2 3 4\n";
print TAB "1 2 3 4\n";
print TAB "2 3 4 5\n";
print TAB "1 2 1 4\n";
print TAB "2 3 4 5\n";
print TAB "1 2 3 4\n";

close TAB;

# remove redundant records
open (TAB, "data.table") or die "Cannot open file data.table: $!\n";
open (NRT, ">table.nr") or die "Cannot open file table.nr: $!\n";

my @table = ();
my $i = 0;
while (my $line = <TAB>) {
	# load table.
	$table[$i] = $line;
	$i++;
}
my @table_nr = ();
my %control = ();
foreach (@table) {
	# use hash to remove redundance
	if (!$control{$_}) {
		push (@table_nr, $_);
	}
	$control{$_}++;
}

# output the non-redundant table.
print NRT "@table_nr\n";

close NRT;
close TAB;
```
