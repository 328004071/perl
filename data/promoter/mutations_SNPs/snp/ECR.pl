#/usr/bin/perl
# 5.计算ESR分值

use strict;
use warnings;

my($WILD, $MUTE) = @ARGV;

open WILD, $WILD or die "no the file:$!";
open MUTE, $MUTE or die "no the file:$!";
open OUT, ">SNP_ECR";
my @w = <WILD>;
my @m = <MUTE>;
close WILD;
close MUTE;

for(my $i = 0; $i < @w; $i++){
	chomp $w[$i];
	chomp $m[$i];
	my @m_l = split /\s+/, $m[$i];
	my @w_l = split /\s+/, $w[$i];
	my $esr = ($m_l[1] - $w_l[1])/($m_l[1] + $w_l[1]);
	
	print OUT $m_l[0]."\t".$w_l[0]."\t".$esr."\n";
}



