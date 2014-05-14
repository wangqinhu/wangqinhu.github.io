---
layout:	post
title:	Download NCBI sequence via perl
tags:	[NCBI, entrez, sequence, perl, database]
date:   Sat Mar 22 22:55:22 CST 2014
---

Usually, we search the NCBI database via entrez and download the sequences by our browser, however, if you are here, I think maybe you had met a lot of network problems. Here is a perl script helps you to query and download ncbi sequences. Enjoy!

``` perl
#!/usr/bin/perl -w

use LWP::Simple;

my $utils = "http://www.ncbi.nlm.nih.gov/entrez/eutils";
my $db     = ask_user("Database", "nucgss");
my $query  = ask_user("Query",    "tobacco[orgn]");
my $report = ask_user("Report",   "fasta");
my $esearch = "$utils/esearch.fcgi?" .
              "db=$db&retmax=1&usehistory=y&term=";
my $esearch_result = get($esearch . $query);

$esearch_result =~ 
  m|<Count>(\d+)</Count>.*<QueryKey>(\d+)</QueryKey>.*<WebEnv>(\S+)</WebEnv>|s;

my $Count    = $1;
my $QueryKey = $2;
my $WebEnv   = $3;

print "Total $Count sequence(s) searched.\n";

my $retstart;
my $retmax=200;

print "Now we will download all the $Count sequence(s).\n";

open (OUT, ">tabacco.fa");
for($retstart = 0; $retstart < $Count; $retstart += $retmax) {
  my $efetch = "$utils/efetch.fcgi?" .
               "rettype=$report&retmode=text&retstart=$retstart&retmax=$retmax&" .
               "db=$db&query_key=$QueryKey&WebEnv=$WebEnv";
  my $efetch_result = get($efetch);
  my $current = ($retstart + $retmax);
  my $percent = 100 * $current / $Count;
  printf "[%7s/%-7s=%7.4f%1s] Finished\n", $current, $Count, $percent, "%";
  print OUT $efetch_result;
}
close OUT;

sub ask_user {
  print "$_[0] [$_[1]]: ";
  my $rc = <>;
  chomp $rc;
  if($rc eq "") { $rc = $_[1]; }
  return $rc;
}
```

This script is a modified version from [http://eutils.ncbi.nlm.nih.gov/corehtml/query/static/eutils_example.pl][1]

[1]: http://eutils.ncbi.nlm.nih.gov/corehtml/query/static/eutils_example.pl

