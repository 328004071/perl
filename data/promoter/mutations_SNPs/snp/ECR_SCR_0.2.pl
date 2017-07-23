#usr/bin/perl
# 6. 以＋／－0.2为阈值，大于则增强，小于则减弱，中间则不变　统计个区间数目

use strict;
use warnings;

my $file = shift;

open INPUT, $file or die "no the file:$!";
open OUT, ">".$file."_c";
my $p;
#my $score = 0;

while(<INPUT>){
	chomp $_;
	my @line = split /\s+/, $_;
	if($line[-1] > 0.2){
		$p->{"0.2"} ++;
	}elsif($line[-1] < -0.2){
		$p->{"-0.2"} ++;
	}else{
		$p->{"0"} ++;
	}
	#$score += $line[-1];
}
close INPUT;

foreach my $key (keys %{$p}){
	print OUT $key."\t".$p->{$key}."\n";
}
#print OUT "average\t".$score."\n";
close OUT;

