#! /usr/bin/perl
use warnings;
use strict;
use Cwd;
use Spreadsheet::WriteExcel;

 my $workbook = Spreadsheet::WriteExcel->new('C:\Users\Administrator\Desktop\esb\newexcel.xls')

 my $worksheet = $workbook->add_worksheet();

        #  添加并定义一个格式        
        my $format = $workbook->add_format();#增加一种格式
        $format->set_bold();              #设置粗体
        $format->set_color( 'red' );      #设置颜色
        $format->set_align( 'center' );   #设置对齐方式（此处为居中）

                #写入一个格式化和非格式化的字符串，使用行列表示法。
        my $col =my $row = 0;                  #设置行和列的位置
        my $worksheet->write( $row, $col, 'Hi Excel!', $format );
        my $worksheet->write( 1, $col, 'Hi Excel!' );

        #使用A1表示法写入一个数字和公式
        my $worksheet->write( 'A3', 1.2345 );         #在第三行第一列写入一个数字
        my $worksheet->write( 'A4', '=SIN(PI()/4)' ); #在第四行第一列写入一个公式
#!/usr/bin/perl
 
# $a = 10;
# while( $a < 20 ){
   # if( $a == 15)
   # {
       # # 跳出迭代
       # $a = $a + 1;
       # next;
   # }
   # print "a 的值为: $a\n";
   # $a = $a + 1;
# }
