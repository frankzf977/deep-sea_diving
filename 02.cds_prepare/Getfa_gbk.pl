#!/usr/bin/perl -w
use strict;
# this script is used for get the cds,pep;perl .pl gz out
my $file=shift;
my $cdsname=shift;
my %hash;
if ($file=~/\.gz$/){
open IN,"gzip -dc $file|" || die "Can't open such file:$!";
}else{
	open IN,"$file" || die "Can't open such file:$!";
	}
$/='//';
open CDS,">$cdsname.cds";
open PEP,">$cdsname.pep";
open GENE,">$cdsname.geneLOC";
while (my $line=<IN>){
#	$line=~s/\\//;
    next unless ($line=~/bp    mRNA    linear/); # This line mach the mRNA file
	my $loc=$1 if ($line=~/\/protein_id=\"(\S+?)\"/); # got the protein name
	my $name=$1 if ($line=~/\/gene=\"(\S+?)\"/); # the genelocus
	next unless ($line=~/\s+CDS\s+(\d+)\.\.(\d+)/);
	my ($star,$end)=$line=~/\s+CDS\s+(\d+)\.\.(\d+)/; # find the start and end
	my $pro=$1 if ($line=~/\/translation="(.+?)\"/s);
	$pro=~s/\s//g;
	my $mRNA=$1 if ($line=~/ORIGIN\s*(.+?)\/\//s);
	$mRNA=~s/\d+//g;
	$mRNA=~s/\s//g;
	my $len=$end-$star+1;
	my $pos=$star-1;
	my $cds=substr($mRNA,$pos,$len); #string,start,end
	$cds = uc($cds); #capital letter
    print CDS ">$loc\n$cds\n";
	print PEP ">$loc\n$pro\n";
	print GENE "$name\t$loc\t$star\t$end\n";
	}
close IN;	
