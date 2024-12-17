#!/usr/bin/perl
use strict;
use warnings;
use File::Path;
use Data::Dumper;

my $gene = shift;

open IN,'<',"./$gene" or die;
open OUT,'>',"step1.txt";
my @all = <IN>;
for my $i (@all) {
	chomp $i;
 print OUT "respgls<- pgls\(log_max_dive_depth\~$i,cdata,lambda=\"ML\"\)\nsummary\(respgls\)\ndimnames(residuals(respgls))\[\[1\]\]\[which.max(abs(residuals(respgls)))\]\nresiduals(respgls)\nAIC(respgls)\n\n\n";
 print OUT "respgls<- pgls\(log_max_dive_time\~$i,cdata,lambda=\"ML\"\)\nsummary\(respgls\)\ndimnames(residuals(respgls))\[\[1\]\]\[which.max(abs(residuals(respgls)))\]\nresiduals(respgls)\nAIC(respgls)\n\n\n";

 

}


close IN;
close OUT;