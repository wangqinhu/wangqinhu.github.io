---
layout:	post
title:	Generate a citation report of your publication
tags:	[perl, citation report, sci, journal, article, author]
date:	2012-02-16 21:22:52
---

Take the FunCat paper in NAR as an example, following this procedure:  
First, download the full report of the query publication from web of knowledge, click [here][1] to get my demo file.  
Second, download all the citations of your query paper in full report format (usually your need to select web of science database rather than all the database), demo file is available [here][2].  
Third, execute the following perl script.
 
NOTE: please save your query and citation file in tab-delimted CRLF format, or you may commit a failure.  
A: total citations exclude the authors citations;  
B: total of the author citations;  
C: citations beyond the year you are retrieved.  
A+B+C is the sum of citations, that is, all the citations in web of science database.  
To preview your finally report file click [here][3].

``` perl
#!/usr/bin/perl -w
# File Name: qsci.pl
# Version 0.01
# Copyright (c) 2012 NWAFU
# Author: Wang Qinhu (qinhu.wang # gmail.com)
# Created on Feb 16, 2012

use strict;

my $label = $ARGV[0] || "citation.report";
my $query = $ARGV[1] || "query.txt";
my $database = $ARGV[2] || "database.txt";
my $year = $ARGV[3] || "2006";

open (QR, $query) or die "Cannot open file $query: $!\n";
my $author = undef;
while (my $line = <QR>) {
	chomp $line;
	if ($line =~ /;/) {
		my @record = split /\t/, $line;
		$author = $record[1];
	}
}
close QR;

my @own_auther = split /\;\s/, $author;

open (DB, $database) or die "Cannot open file $database: $!\n";
my @citation = ();
my $i = 0;
while (my $dbr = <DB>) {
	$citation[$i++] = $dbr;
}
close DB;

open (RP, ">$label.txt") or die "Cannot open file $label.txt: $!\n";
my $a = 0;
my $b = 0;
my $c = 0;

foreach my $i (1..$#citation) {
	my $ci = $citation[$i];
	my $own = 0;
	my $once = 0;
	my @split_sci = split /\t/, $ci;
	if ($split_sci[37] >= $year) {
		foreach my $au (@own_auther) {
			if ($ci =~ /$au/) {
				$own++ if $once++ == 0;
			}
		}
		if ($own == 0) {
			$a++;
			print RP "//\nType: A\n";
			print RP "Author(s): $split_sci[1]\n";
			print RP "Title: $split_sci[7]\n";
			print RP "Journal: $split_sci[8]\n";
			print RP "Year: $split_sci[37]\n";
			print RP "Volume: $split_sci[38]\n";
		} else {
			$b++;
			print RP "//\nType: B\n";
			print RP "Author(s): $split_sci[1]\n";
			print RP "Title: $split_sci[7]\n";
			print RP "Journal: $split_sci[8]\n";
			print RP "Year: $split_sci[37]\n";
			print RP "Volume: $split_sci[38]\n";		
		}
	} else {
		$c++;
		print RP "//\nType: C\n";
		print RP "Author(s): $split_sci[1]\n";
		print RP "Title: $split_sci[7]\n";
		print RP "Journal: $split_sci[8]\n";
		print RP "Year: $split_sci[37]\n";
		print RP "Volume: $split_sci[38]\n";
	}
}

print RP "\n***********************\n";
print RP "Citation Report:\n";
print RP "A\t$a\n";
print RP "B\t$b\n";
print RP "C\t$c\n";
print RP "***********************\n\n";
close RP;
```

[1]: /data/qsci/query.txt
[2]: /data/qsci/database.txt
[3]: /data/qsci/citation.report.txt
