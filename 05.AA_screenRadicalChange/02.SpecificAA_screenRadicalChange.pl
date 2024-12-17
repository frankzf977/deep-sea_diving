#!/usr/bin/perl
use strict;
use warnings;
use Cwd;
use Data::Dumper;

#perl 02.SpecificAA_screenRadicalChange.pl unique_AA_input.txt >unique_AA_input.OUT.txt

my %chargePositive = ('R'=>'11','H'=>'11','K'=>'11');
my %chargeNegative = ('D'=>'12','E'=>'12');
my %chargeNeutral = ('A'=>'13','N'=>'13','C'=>'13','Q'=>'13','G'=>'13','I'=>'13','L'=>'13','M'=>'13','F'=>'13','P'=>'13','S'=>'13','T'=>'13','W'=>'13','Y'=>'13','V'=>'13');

my %polarityPolar = ('R'=>'21','N'=>'21','D'=>'21','C'=>'21','Q'=>'21','E'=>'21','G'=>'21','H'=>'21','K'=>'21','S'=>'21','T'=>'21','Y'=>'21');
my %polarityNonpolar = ('A'=>'22','I'=>'22','L'=>'22','M'=>'22','F'=>'22','P'=>'22','W'=>'22','V'=>'22');

my %PVspecial = ('C'=>'31');
my %PVneutralSamll = ('A'=>'32','G'=>'32','P'=>'32','S'=>'32','T'=>'32');
my %PVpolarRelativelySmall = ('N'=>'33','D'=>'33','Q'=>'33','E'=>'33');
my %PVpolarRelativelyLarge = ('R'=>'34','H'=>'34','K'=>'34');
my %PVnonpolarRelativelySmall = ('I'=>'35','L'=>'35','M'=>'35','V'=>'35');
my %PVnonpolarRelativelyLarge = ('F'=>'36','W'=>'36','Y'=>'36');

my $in = $ARGV[0];
open IN, "<$in";
while (<IN>) {
	my $result = "#";
	my @a = split /\t/, $_;
	chomp $a[-1];
	$a[1] =~ /(\w)\(/;
	my $p1 = $1;
	$a[2] =~ /(\w)\(/;
	my $p2 = $1;
	if (exists $chargePositive{$p1} && !(exists $chargePositive{$p2})) {$result = "charge";}
	elsif (exists $chargeNegative{$p1} && !(exists $chargeNegative{$p2})) {$result = "charge";}
	elsif (exists $chargeNeutral{$p1} && !(exists $chargeNeutral{$p2})) {$result = "charge";}
	elsif (exists $polarityPolar{$p1} && !(exists $polarityPolar{$p2})) {$result = "polarity";}
	elsif (exists $polarityNonpolar{$p1} && !(exists $polarityNonpolar{$p2})) {$result = "polarity";}
	elsif (exists $PVspecial{$p1} && !(exists $PVspecial{$p2})) {$result = "polarity&volume";}
	elsif (exists $PVneutralSamll{$p1} && !(exists $PVneutralSamll{$p2})) {$result = "polarity&volume";}
	elsif (exists $PVpolarRelativelySmall{$p1} && !(exists $PVpolarRelativelySmall{$p2})) {$result = "polarity&volume";}
	elsif (exists $PVpolarRelativelyLarge{$p1} && !(exists $PVpolarRelativelyLarge{$p2})) {$result = "polarity&volume";}
	elsif (exists $PVnonpolarRelativelySmall{$p1} && !(exists $PVnonpolarRelativelySmall{$p2})) {$result = "polarity&volume";}
	elsif (exists $PVnonpolarRelativelyLarge{$p1} && !(exists $PVnonpolarRelativelyLarge{$p2})) {$result = "polarity&volume";}
	else {$result = "not_radical";}
	unshift @a, $result;
	my $new = join ("\t", @a);
	print "$new\n";
}


