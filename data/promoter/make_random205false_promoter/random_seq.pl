#!/bin/perl
#
#产生随机序列
#　作者：施梦军（Shi Mengjun）
#  单位：安徽大学
use strict;
use warnings;

my $label = shift;
my $number = shift;
my $file = shift;
my @outdata;

open FILE, $file or die "no the file: $!";
my @data = <FILE>;
close FILE;

sub match($$){
	my $outdata = shift;
	my $seq = shift;
	my $flag = 0;
	
	for(my $j=0; $j < @$outdata; $j++){
		if($seq eq $outdata[$j]){
			$flag = 1;
			return $flag;
		}
	}
	return $flag;
}

for(my $i = 0; $i < $number; ){	
	my $num = int(rand(3892));
	print $num."\n";
	chomp $data[$num];
	my $flag = match(\@outdata,$data[$num]);
	if($flag == 0){
		$outdata[$i] = $data[$num];
		print $data[$num]."\n";	
		$i++;
	}	
}

open OUT, ">$label";
for(my $i = 0; $i < @outdata; $i++){
	print OUT $outdata[$i]."\n";
}
close OUT;



