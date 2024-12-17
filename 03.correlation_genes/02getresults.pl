#!/usr/bin/perl
use strict;
use warnings;
use File::Path;
use Data::Dumper;


my $file = shift;
open IN, "$file" or die;
open OUT,">result.txt" or die;
print OUT "gene\tlambda\tCofficients\tr2\tpvalue\tSpecies\tAIC\n";
ONE:while (my $line=<IN>) {
	my $gene;
	if ($line=~/pgls\(formula = (.*), data/){
		$gene = $1 ;
		print OUT "$gene\t";
		} elsif ($line =~ /^lambda(.*)$/){
	      my $lambda = $1;
          $lambda =~ s/\[ ML\]\s*\://g;
	      print OUT "$lambda\t";
	    } elsif ($line =~ /\(Intercept\)/){
          my ($a, $b, $c, $d, $e, $f) = split(/\s+/, $line, 6);
          print OUT "$b\t";
        } elsif ($line =~ /Multiple R-squared: (.*),\sAdjusted R-squared: (.*)$/){
          my $r = $2;
          print OUT "$r\t";
        } elsif ($line =~ /F-statistic(.*)p-value: (.*)$/){
          my $p = $2;
          print OUT "$p\t";
        } elsif ($line =~ /\[1\]\s"(.*)"/){
          my $species = $1;
          print OUT "$species\t";
        } elsif ($line =~ /\[1\]\s(.*)/){
          print OUT "$1\n";
        }    
    }