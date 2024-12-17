#!/usr/bin/perl
use strict;
use warnings;
use File::Path;

my $gene_file_dir = 'gene';  #建立gene的文件夹，放所有的fas文件。同时告诉gene文件路径
my $tree_file_dir = 'tree';  #建立tree的文件夹，放所有的tree文件。如果所有基因的树都一致的话，推荐使用此法

opendir INTREE, "$tree_file_dir" or die "cannot open tree: $!";  #打开tree文件
opendir INGENE, "$gene_file_dir" or die "cannot open gene: $!";  #打开gene文件
my @alltrees = readdir INTREE; #目录读取tree文件中的每个tree，组成列表
my @allgenes = readdir INGENE;  #目录读取gene文件中的每个gene，组成列表
closedir INGENE;
closedir INTREE;

for my $gene (@allgenes) {  #读取列表里的每一个基因
    next if $gene =~ /^\./; #如果匹配到mac的隐藏文件（该文件一般以.开头），就跳出循环
    for my $tree (@alltrees) {  #读列表里每棵树
        next if $tree =~ /^\./;
        mkpath("$gene/$tree/ma"); #创建目录ma
        `cp ./$tree_file_dir/$tree ./$gene/$tree/ma`; #执行shell命令，将树复制到ma文件夹中
        `cp ./$gene_file_dir/$gene ./$gene/$tree/ma`;  #执行shell命令，将gene复制到ma文件夹中
        open my $fhctl, ">", "./$gene/$tree/ma/codeml.ctl" or die; #读写模式打开ctl文件，向ctl文件中写入内容，若文件不存在则创建之
        print $fhctl  #将需要的ctl参数写入
            "seqfile = $gene\ntreefile = $tree\noutfile = $tree\_out\nnoisy = 0\nverbose = 2\nrunmode = 0\nseqtype = 1\nCodonFreq = 2\nclock = 0\naaDist = 0\naaRatefile = dat\/jones.dat\nmodel = 2\nNSsites = 2\nicode = 0\nMgene = 0\nfix_kappa = 0\nkappa = 2\nfix_omega = 0\nomega = 0.5\nfix_alpha = 1\nalpha = 0.\nMalpha = 0\nncatG = 8\ngetSE = 0\nRateAncestor = 1\nSmall_Diff = .5e-6\ncleandata = 0";
        close $fhctl;
        mkpath("$gene/$tree/ma0"); #创建目录ma0
        `cp ./$tree_file_dir/$tree ./$gene/$tree/ma0`; #同ma步骤
        `cp ./$gene_file_dir/$gene ./$gene/$tree/ma0`;
        open $fhctl, ">", "./$gene/$tree/ma0/codeml.ctl" or die;
        print $fhctl
            "seqfile = $gene\ntreefile = $tree\noutfile = $tree\_out\nnoisy = 0\nverbose = 2\nrunmode = 0\nseqtype = 1\nCodonFreq = 2\nclock = 0\naaDist = 0\naaRatefile = dat\/jones.dat\nmodel = 2\nNSsites = 2\nicode = 0\nMgene = 0\nfix_kappa = 0\nkappa = 2\nfix_omega = 1\nomega = 1\nfix_alpha = 1\nalpha = 0.\nMalpha = 0\nncatG = 8\ngetSE = 0\nRateAncestor = 1\nSmall_Diff = .5e-6\ncleandata = 0";
        close $fhctl;
    }
}
