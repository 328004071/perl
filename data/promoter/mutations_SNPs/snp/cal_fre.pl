#/usr/bin/perl
# 4. 计算频率
use strict;
use warnings;
my $file = shift;

open FILE, $file or die "no the file:$!\n";
open OUT, ">".$file."-distribution";
print OUT "range"."\t"."number"."\t"."frequence\n";
my @data = <FILE>;
close FILE;

my $hdata;
for(my $n = -1.0; $n < 1.0;) {
	my $c = $n + 0.1;
	$n = sprintf "%.1f", $n;
	$c = sprintf "%.1f", $c;
	my $k = "[".$n.",".$c.")";				
	$hdata->{$k} = 0;
	$n += 0.1;
}

for(my $m = 0; $m < @data; $m++) {
	chomp $data[$m];
	my @rdata = split(/\t/, $data[$m]);
	print "raw:".$m."\t".$rdata[-1]."\n";
	for(my $n = -1.0; $n < 1.0;) {
		my $c = $n + 0.1;
		$n = sprintf "%.1f", $n;
		$c = sprintf "%.1f", $c;
		my $k = "[".$n.",".$c.")";				
		if( $rdata[-1] >= $n && $rdata[-1] < $c) {
			$hdata->{$k} ++;
		}
			$n += 0.1;
	}
}
foreach my $k (sort keys %$hdata) {
	my $f = $hdata->{$k}/(@data-1);
	$f = sprintf "%.9f", $f;
	print OUT $k."\t".$hdata->{$k}."\t\t".$f."\n";
}
close OUT;
