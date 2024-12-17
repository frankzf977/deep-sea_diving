#!/usr/bin/perl 
use strict;
use warnings;
use lib "/share/app/perl-5.24.1/lib/site_perl/5.24.1/x86_64-linux-thread-multi/";
use Math::CDF qw(pchisq);
use Cwd;

my $result_file = shift;
opendir FF, "$result_file" or die;

my @files = grep(/fas$/i, readdir FF);
#print "@files";


open OUT,">two_result_all.txt" or die;
print OUT "Gene\tBranch\tModel\tLnL\t2LnL\tp\tparameters\n";


for my $i (@files){
	opendir IN,"./$result_file/$i" or die;
	my @second = grep(/\.nwk$/i, readdir IN);
	for my $j (@second){
		open GG,"$result_file/$i/$j/ma/${j}_out" or die;
		my ($lnL1,$lnL2,$w_back,$w_fore,$w0,$lnL3,$w00) = (0,0,0,0,0,0,0);#赋值，初始值为0
		while (my $info = <GG>){
			chomp $info;
			if ($info =~ /^lnL/){
				$lnL1 = (split /\s+/,$info)[4];
			}elsif($info =~ /^w \(dN\/dS\) for branch/){
				($w_back,$w_fore) = (split /\s+/,$info)[4,5];
			}
		}
		close GG;
		open ONE,"$result_file/$i/$j/m0/${j}_out" or die;
		while (my $info1 = <ONE>){
			chomp $info1;
			if ($info1 =~ /^lnL/){
				$lnL2 = (split /\s+/,$info1)[4];
			}elsif($info1 =~ /^omega \(dN\/dS\)/){
				$w0 = (split /\s+/,$info1)[3];
			}
		}
		close ONE;
=cut
		open WW,"$result_file/$i/$j/w=1/${j}_out" or die;
		while (my $info3 = <WW>){
			chomp $info3;
			if ($info3 =~ /^lnL/){
				$lnL3 = (split /\s+/,$info3)[4];
			}elsif($info3 =~ /^w \(dN\/dS\)/){
				$w00 = (split /\s+/,$info3)[4];
			}
		}
		close WW;
=cut
		my $x=2*($lnL1-$lnL2);
		$x=abs($x);
		my $p=1-pchisq($x,1);
=cut
		my $xx=2*($lnL3-$lnL1);
		$xx=abs($xx);
		my $p2=1-pchisq($xx,1);
=cut
		#if ($p lt 0.05){
			print OUT "$i\t$j\tm0\t$lnL2\t \t \tw0=$w0\n";
			print OUT "$i\t$j\ttwo_ratio\t$lnL1\t$x\t$p\tw0=$w_back;w1=$w_fore\n";
		#}
		
=cut		
	#	if ($p2 lt 0.05){
			print OUT "$i\t$j\ttwo_ratio\t$lnL1\t \t \tw0=$w_back;w1=$w_fore\n";
			print OUT "$i\t$j\ttwo_ratio (w=1)\t$lnL3\t$xx\t$p2\tw0=$w00;w1=1.000\n";
	#	}
=cut			
		
	}
}
close IN;
close OUT;


