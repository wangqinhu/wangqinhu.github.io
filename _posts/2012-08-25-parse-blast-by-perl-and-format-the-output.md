---
layout:	post
title:	Parse blast by Perl and format the output
tags:	[blast, parse, perl, format, output, sequence, fasta, bioperl, bioinformatic]
date:	2012-08-26 01:14:46
---

Parse blast result is frequently used in our daily research, here is my script for parsing the original blast output, include the full report in tab-delimited format and brief in tab-delimited format, which can be easily identified in Excel or a Text editor.

For example, we have a demo sequence file named [seq.fas][1], we performed blast search by typing the following:

```    
blastall -p blastp -i seq.fas -d /disk/www/blast/db/nr -e 1e-10 -b 3 -v 3 -a 8 -o blast.out
``` 

The output file is like [this][2].  
After that, please run this script as following:

```
perl parse_blast.pl
```
    
And you will get two report files in full and brief tab-delimited formats.  
Those are the demo output files: [full_tab][3] [brief_tab][4]  
Hope this is useful for you.  
Here is the code:  
[click [here][5] to save this file directly]

``` perl

#!/usr/bin/perl -w

use strict;
use Bio::SearchIO;

my $blast_file = $ARGV[0] || "blast.out";
my $report = $ARGV[1] || 'blast.report';
my $evalue = undef;

open (RPT,">$report");
print RPT "#Query_Name\tTop_Hit\tDescription [Organism]\tE-value\n";
my $in = new Bio::SearchIO(
-format => 'blast',
-file   => "$blast_file");
while(my $result = $in->next_result) {
	while(my $hit = $result->next_hit) { 
		while(my $hsp = $hit->next_hsp) {                       
				print RPT $result->query_name, "\t";
				print RPT $hit->name, "\t", $hit->description, "\t";
				$evalue = $hsp->evalue;
				$evalue =~ s/\,//;
				print RPT $evalue, "\n";
				last;
		}
		last;
	}
}
close(RPT);

open (REC, "$report");
open (BRI, ">$report.xls");
while (my $line = <REC>) {
	my ($a, $b, $c, $d) = split /\t/, $line;
	my ($c_head, $c_tail) = split /\]/, $c, 2;
	my $rec = "$a\t$b\t$c_head]\t$d";
	$rec =~ tr/\[//;
	print BRI $rec;
}
close REC;
close BRI;

 [1]: /data/blast/seq.fas
 [2]: /data/blast/blast.out
 [3]: /data/blast/blast.report
 [4]: /data/blast/blast.report.xls
 [5]: /data/blast/parse_blast.pl
