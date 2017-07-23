#perl
#在不同支持度和保守长度下运行shift_pattern_2.pl程序，产生打分倾向值文件和倾向值频率分布
#　$i 表示支持度，　$j 表示保守位置长度
#　作者：施梦军（Shi Mengjun）
#  单位：安徽大学
use strict;
use warnings;
#use Switch;

my $file1 = shift; # positive_sample eg: ESE
my $file2 = shift; # negative_sample eg: ESS
my $file3 = shift; # test_sanple

for(my $i = 0.02; $i < 0.03;) {
	for(my $j = 3; $j < 4; $j++) {		
		print "支持度:".$i."\t保守项:".$j."\n";
		`perl shift_pattern_2.pl -file1 $file1 -file2 $file2 -test $file3 -minsup $i -SFno $j`;
		
		my $file = $file3."-score-result-based-".$i."-".$j."SF";
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
