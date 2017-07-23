#usr/bin/perl
# 3.统计ASMD每个突变11聚体的分值

use strict;
use warnings;

my($seq11, $score) = @ARGV;
open ASMD, $seq11 or die "no the file:$!";
open SCORE, $score or die "no the file:$!";
my @name = split /_/, $score;
open OUT, ">".$name[0]."_wild_score";

my @data_a = <ASMD>;
my @data_s = <SCORE>;
chomp @data_a;
chomp @data_s;
close ASMD;
close SCORE;

my $ese = 0;
my $ess = 0;
my $j = 0;

for(my $i = 1; $i < @data_s; $i++){
	my @line = split /\s+/, $data_s[$i];
	if($i % 6 == 0){
		$ese += $line[1];
		$ess += $line[2];		
		my @seq = split /\r/, $data_a[$j];
		$j += 2;
		my $tr = ($ese - $ess) / ($ese + $ess);
		print OUT $seq[0]."\t".$ese."\t".$ess."\t".$tr;
		print OUT "\n";	
		$ese = 0;
		$ess = 0; 
		
	}else{
		$ese += $line[1];
		$ess += $line[2];
	}
}
close OUT;
