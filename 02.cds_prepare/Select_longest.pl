#!/usr/bin/perl
use strict;
use warnings;
# use age perl Select_longest.pl gbk.geneLOC gbk.cds >lst.cds
my $file= shift;#lsit files
my $file2= shift;# database cds file
my %hash;
my %hash_seq;
open IN,"$file" || die $!;
while (<IN>){
	chomp;
	my @t=split /\s+/,$_;
		$hash{$t[0]}{$t[1]}=$t[3]-$t[2]+1;#键为基因名 id，值为长度
	}
close IN;
my %fg;
foreach my $loc (keys %hash){
	my @t= keys %{$hash{$loc}};#基因名和id作为数组的元素，为一个整体，二维数组
	my $temp=$t[0];#基因名和id
	if (@t<2){  #数组元素个数小于2，说明只有单个转录本 
	$fg{$temp}=1;  #值设为多少无所谓，最后只需要输出键
	}else {
		foreach (@t){
			$temp= $hash{$loc}{$temp}>$hash{$loc}{$_}? $temp :$_;  #比较不同转录本的长度，如拿hash的第0个键的值与第1个键的值去比较，查看三元操作符用法
			}
		$fg{$temp}=1;	
		}
	}
if ($file2=~/\.gz/){
	open IN2,"gzip -dc $file2|" || die $!;
	}else {
open IN2,"$file2" || die $!};
$/=">";
<IN2>;
$/="\n";
while (<IN2>){
	my $name=$1 if (/^(\S+)/);
	$/=">";
	my $seq=<IN2>;
	$/="\n";
	$seq=~s/>$//g;
   if (exists $fg{$name}){
	   print ">$name\n$seq"
	   }
	}
close IN2;	
