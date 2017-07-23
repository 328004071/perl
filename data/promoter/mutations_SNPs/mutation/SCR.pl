#/usr/bin/perl
# 5.计算SCR分值

use strict;
use warnings;

my($WILD, $MUTE) = @ARGV;

open WILD, $WILD or die "no the file:$!";
open MUTE, $MUTE or die "no the file:$!";
open OUT, ">mutation_SCR";
my @w = <WILD>;
my @m = <MUTE>;
close WILD;
close MUTE;

for(my $i = 0; $i < @w; $i++){
	chomp $w[$i];
	chomp $m[$i];
	my @m_l = split /\s+/, $m[$i];
	my @w_l = split /\s+/, $w[$i];
	my $esr = ($m_l[2] - $w_l[2])/($m_l[2] + $w_l[2]);
	
	print OUT $m_l[0]."\t".$w_l[0]."\t".$esr."\n";
}



