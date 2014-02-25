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

__END__
