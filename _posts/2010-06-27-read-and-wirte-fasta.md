---
layout:	post
title:	Read and write a sequence in fasta format by Perl
tags:	[fasta, bioinformatic, perl, read, write, sequence]
date:	2010-06-27 11:11:29
---

Well, fasta format is defined as a sequence begin with ">", followed by its identifier in the first line, and the sequence itself is stored in the next lines. The sequence can be multiple and it is one of the most popular sequence format in bioinformatics. For large scale sequence analysis, the basic thing is to read and write sequence in fasta format, here I supply the basic way to aid your daily work, note it is not the only way!

``` perl
# read sequence in fasta format
sub read_fasta {
	
	my (@fasta_file) = @_;

	# declare and initialize variables
	my $sequence = '';
	
	foreach my $line (@fasta_file) {

		# discard blank line
		if ($line =~ /^\s*$/) {
			next;
		}
		# discard comment line
		elsif ($line =~ /^\s*#/) {
			next;
		}
		# discard fasta header line
		elsif ($line =~ /^>/) {
			next;
		# keep line, add to sequence string	
		} else {
			$sequence .= $line;
		}
	}
}

# write sequence in fasta format
sub write_fasta {

	my ($sequence, $length) = @_;

	# print sequence in lines of $length
	for ( my $pos = 0 ; $pos < length($sequence) ; $pos += $length ) {
		print substr($sequence, $pos, $length), "\n";
	}

}
```
