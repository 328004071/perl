
# perl
这个是shift_pattern算法的代码．．．．．      
简单说明：   
  shift_pattern/Algorithm为算法引用的PrefixSpan包，改写了其中的代码，改名为PrefixSpan_1；   
  shift_pattern/shift_pattern_2.pl 为代码实现部分；   
  shift_pattern/run_shift_pattern.pl 为运行代码，为了实现批处理编写，也可以直接使用shift_pattern_2.pl．   

输入数据：   
  训练集与测试集都是等长基因序列，形如  
            AAAAAG  
            AAAACC  
            AAAAGA  
            AAAAGC  
  支持度与保守序列长度根据实际选取，这些参数可在run_shift_pattern.pl中修改，也可在shift_pattern_2.pl直接运行时当参数输入  
输出数据：
  文件1记录测试集各序列在正反训练集所属类别中的分值及倾向值  
  文件2记录倾向值频率的区间分布
