#! /usr/bin/perl
use warnings;
use strict;
use Cwd;
use Spreadsheet::ParseExcel;
use Spreadsheet::WriteExcel;

my $parser = Spreadsheet::ParseExcel->new();
my $workbook = $parser->parse('C:\Users\Administrator\Desktop\esb\1.xls');

if (!defined $workbook){
die $parser->error(), ".\n";
}
my @array;
my %num;
my $locate;
for my $worksheet($workbook->worksheets){
		
		my( $row_min, $row_max) = $worksheet->row_range();
		my( $col_min, $col_max) = $worksheet->col_range();
		for my $row($row_min .. $row_max){
				for my $col($col_min .. $col_max){
						 my $cell = $worksheet->get_cell($row, $col);
						 $locate = "$row,$col";
						 # print "yes is $locate\n";
						 print ("row col:($row,$col) \n");
						 print "value :" ,$cell->value() ," \n";
						 $num{$locate} = $cell->value();
						 # print ("now is $num{$locate}\n");
						 push @array,$cell->value;
						}
				}
		}
		close $workbook;
		
my $workbook1 = Spreadsheet::WriteExcel->new('C:\Users\Administrator\Desktop\esb\newexcel.xls');

my $worksheet = $workbook1->add_worksheet(); 
        $col = $row = 0;                  #设置行和列的位置
        $worksheet->write( $row, $col, 'Hi Excel!', $format );
        $worksheet->write( 1, $col, 'Hi Excel!' );

        #使用A1表示法写入一个数字和公式
        $worksheet->write( 'A3', 1.2345 );         #在第三行第一列写入一个数字
        $worksheet->write( 'A4', '=SIN(PI()/4)' ); #在第四行第一列写入一个公式
