#perl
use strict;
use warnings;
#　作者：施梦军（Shi Mengjun）
#  单位：安徽大学
# 生成不含真假序列的所有6聚体
my $label = shift;
my $file1 = shift;
#my $file2 = shift;
#my $file3 = shift;

open FILE1, $file1 or die "no the file: $!";
#open FILE2, $file2 or die "no the file: $!";
#open FILE3, $file3 or die "no the file: $!";

my @data1 = <FILE1>;
#my @data2 = <FILE2>;
#my @data3 = <FILE3>;

close FILE1;
#close FILE2;
#close FILE3;

open OUT, ">rest"."_".$label."_sequence_6";
my @item = ("A", "G", "C", "T");
my $fileout = *OUT;
&allong(0,"",$fileout,\@data1);
#&allong(0,"",$fileout,\@data1,\@data2);

sub allong($$$$) {
	my $n = shift;
	my $sequence = shift;
	my $fileout = shift;
	my $data1 = shift;
	#my $data2 = shift;

	if ($n == 6) {
		#my $sit = match($sequence, $data1, $data2);
		my $sit = match($sequence, $data1);		
		if($sit == 0 ) {
			print $sequence."\n";
			print $fileout $sequence."\n";
		}
	}else {
		$n ++;
		for(my $i = 0; $i < @item; $i++) {
			#&allong($n, $sequence.$item[$i], $fileout, $data1, $data2);	
			&allong($n, $sequence.$item[$i], $fileout, $data1);
		}
	}
}

sub match($$) {
	my $sequence = shift;
	my $data1 = shift;
	#my $data2 = shift;
	my $sit = 0;
	for(my $i = 0; $i < @$data1; $i ++) {
		chomp $data1[$i];
		if($sequence eq $data1[$i]) {
			$sit = 1;
			return $sit;
		}
	}
	#for(my $i = 0; $i < @$data2; $i ++) {
	#	chomp $data2[$i];
	#	if($sequence eq $data2[$i]) {
	#		$sit = 1;
	#		return $sit;
	#	}
	#}
}

close OUT;





