#!/usr/bin/perl
use strict;
use warnings;


#perl trans_form.pl specific_sites.4719.gene.txt

my $file = $ARGV[0];
open OUT,">$file.filtered.txt" or die;

my $ori = $/;
$/ = "2023";
#print "$/";
my %hash;
open IN,"$file" or die;
while (my $line = <IN>){
	next if ($line =~ /^2022/);
	#print "$line\n";
	chomp $line;
	my @a = (split /\$\//,$line);
	#my $number=@a;
	#print "@a\n";
	for (my $i=0;$i<@a;$i++){
		my @tep = split /\n/,$a[$i];
		#print "@tep\n";
		my $name =shift @tep;
		#print "$name\n";
		#$name =~s/-07(.*)NP/NP/g;
	#print "$name";
		#$name =~s/-07(.*)XP/XP/g;
		#print "$name";
		my $position = shift @tep;
		my $number=@tep;
		#print "$number\n";
		next if ($number > "20"); 
		foreach my $site (@tep){
			#print "$site";
			#chomp $site;
			push @{$hash{$name}},$site;
		}
	}
	
	
}
close IN;
$/ =$ori;

foreach my $gene (keys %hash){
	#$gene =~s/-.*://g;
	print "$gene\n";
	my @temp =@{$hash{$gene}};
	#print "@temp\n";
	foreach my $i (@temp){
	$gene =~s/-.*: //g;
	#print "$gene\n";
		print OUT "$i\t$gene\n";
	}
	
}
