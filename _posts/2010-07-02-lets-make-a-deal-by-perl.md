---
layout:	post
title:	Let's make a deal by Perl
tags:	[perl, bayesian, make a deal, strategy]
date:	2010-07-02 11:10:25
image:
  feature: L77.jpg
---

Let's make a deal is a fashion TV game, here I designed a Perl script to simulate this game and print the result of the game. In fact, this is some basic about Bayesian theory.

``` perl
#!/usr/bin/perl -w

# Let's make a deal

use strict;

my $award = undef;
my $host = undef;
my $guest_1st = undef;
my $guest_2nd = undef;
my $count = 0;
my $strategy = $ARGV[0] || "1"; # strategy belongs to {1,2} = {swtichi, not switch}
my %strategy = ("1" => "swtich", "2" => "not switch");
my $time = $ARGV[1] || "10000";

for (my $i = 0; $i < $time; $i++) {
	
	# set award
	$award = int(3 * rand);
	
	# guest guess
	$guest_1st = int(3 * rand);
	
	# host opens the box (non-award)
 	($host) = judge($award, $guest_1st);
	
 	# guest guess again
	$guest_2nd = guess($guest_1st, $host, $strategy);
	
	# counts
	if ($guest_2nd == $award) {
  	  $count++;
	}
}

my $right = $count / $time;

print "By ", $strategy{$strategy}, "ing, you won ", 100 * $right, "\%\.\n";

sub guess{
	my ($guest_1st, $host, $strategy) = @_;
	if ($strategy == 1) {
		$guest_2nd = 3 - $guest_1st - $host;
	} elsif ($strategy == 2) {
		$guest_2nd = $guest_1st;
	} else {
		print "Are you kid me?\n";
	}
	return $guest_2nd;
}

sub judge {
	my ($award, $guest_1st) = @_;
	my $host = undef;
	if ($award == $guest_1st) {
		$host = 3 - $award - dice($award);
	}
	if ($award != $guest_1st) {
		$host = 3 - $award - $guest_1st;
	}
	return $host;
}

sub dice {
	my ($award) = @_;
	my $dice = rand;
	if ($award == 1) {
		if ($dice <= 0.5) {
			$dice = 0;
		} else {
			$dice = 2;
		}
	} elsif ($award == 2) {
		if ($dice <= 0.5) {
			$dice = 0;
		} else {
			$dice = 1;
		}
	} else {
		if ($dice <= 0.5) {
			$dice = 1;
		} else {
			$dice = 2;
		}
	}
	return $dice;
}
```
