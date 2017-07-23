#perl
use strict;
use warnings;
#use Switch;

my $file1 = shift;
my $file2 = shift;
my @file3 = @ARGV;

foreach (@file3) {
for(my $i = 0.02; $i < 0.06;) {
	for(my $j = 2; $j < 5; $j++) {		
		print "支持度:".$i."\t保守项:".$j."\n";
		`perl shift_pattern_2.pl -file1 $file1 -file2 $file2 -test $_ -minsup $i -SFno $j`;
		
		my $file = $_."-score-result-based-".$i."-".$j."SF";
		print $file."\n";
		open FILE,$file or die "no the file:$!\n";
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

		for(my $m = 1; $m < @data; $m++) {
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
	}
 	$i += 0.01;
	$i = sprintf "%.2f", $i;

}
}
