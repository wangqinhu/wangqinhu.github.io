---
layout:	post
title:	cas9off - large scale off-target analysis tool for crispr/cas9 system
tags:	[cas9off, off target, crispr, cas9, perl, tool, large scale, offscan.pl]
date:	2014-02-21 11:56:54
image:
  feature: L77.jpg
---

cas9off version 1.0
-------------------

```
ABOUT
         offscan.pl - A perl script used for large scale profiling possible
                      target sites of CRISPR/CAS9 system by using seqmap

VERSION
         Version: 1.0
         Feb 8, 2014

SYNOPSIS
         $ perl ./offscan.pl <option>
         For usage, type './offscan.pl -h'
         To test a demo, type './offscan.pl -t'

DESCRIPTION
         This script takes a FASTA file of the target sites and queries the
         reference database by seqmap tolerant designated mismatches, and gives
         the human readable and computer mineable target/off target sites and
         flanking sequencing, also the summary file.

         Seqmap is describled:
         Jiang, H. and Wong, WH. (2008) SeqMap: mapping aassive amount of
         oligonucleotides to the genome, Bioinformatics, 24(20):2395-2396.
         And available at http://www-personal.umich.edu/~jianghui/seqmap/

         This script is used in the following research:
         Guo, XG., Zhang, TJ., Hu, Z., Zhang, YQ., Shi ZY., Wang, QH., Cui, Y.,
         Wang, FQ., Zhao, H. and Chen, YL. (2014) Efficient RNA/Cas9-mediated
         genome editing in Xenopus tropicalis. Development, 141(3):707-714.

NOTE
         1. Max number of mismatch (option -n) is 5.
         2. The type memory size (option -m) is a number. Unit: megabyte.
         3. User can download the latest seqmap and replace the one included in
            directory 'bin'.

AUTHOR
         Wang, Qinhu
         Northwest A&F University
         E-mail: wangqinhu@nwafu.edu.cn

LICENSE
         For non-commercial use only.
		 


cas9off version 1.0
===================

Usage:

    offscan.pl <option>
    
    -h  Help
    -t  Test demo
    -q  Query file, in FASTA format, contains the target sites
    -r  Query site length, default is 23 bp, including NGG
    -d  Database file, in FASTA format, contains reference sequences
    -l  Length of flanking sequences to extract, default is 500 bp
    -n  Number of mismatch (0-5), does not include NGG
    -o  Output filename, default is cas9off.xls
    -s  Summary filename, default is sum.xls
    -m  Memory size, default is 2048 [Mb (2Gb)]
    -f  Format reference sequence,
	optional unless your FASTA file has annotation

    For citation:
	
    * Jiang, H. and Wong, WH. (2008) SeqMap: mapping aassive amount of 
      oligonucleotides to the genome, Bioinformatics, 24(20):2395-2396.
	
    * Guo, XG., Zhang, TJ., Hu, Z., Zhang, YQ., Shi ZY., Wang, QH., Cui, Y.,
      Wang, FQ., Zhao, H. and Chen, YL. (2014) Efficient RNA/Cas9-mediated
      genome editing in Xenopus tropicalis. Development, 141(3):707-714.	  

```

Source code is available at <https://github.com/wangqinhu/cas9off>
