#usr/bin/perl
# 将11聚体序列分割成6个6聚体

use strict;
use warnings;

my $file = shift;
open INPUT, $file or die "no the file:$!";
open WILD, ">".$file."_wild";
open MUTE, ">".$file."_mute";

my $n = 0;
while(<INPUT>){
	chomp $_;
	$n ++;
	my @line = split //, $_;
	for(my $i = 0; $i < 6; $i++ ){
		my $j = 0;
		for(; $j < 6; $j++){
			if($n % 2 == 1){
				print WILD $line[$i+$j];
			}else{
				print MUTE $line[$i+$j];
			}		
		}
		print WILD "\n";
		print MUTE "\n";
	}
}
close INPUT;
close WILD;
close MUTE;

