#! /usr/bin/perl
use warnings;
use strict;
use Cwd;
use Spreadsheet::WriteExcel;

 my $workbook = Spreadsheet::WriteExcel->new('C:\Users\Administrator\Desktop\esb\newexcel.xls')

 my $worksheet = $workbook->add_worksheet();

        #  ��Ӳ�����һ����ʽ        
        my $format = $workbook->add_format();#����һ�ָ�ʽ
        $format->set_bold();              #���ô���
        $format->set_color( 'red' );      #������ɫ
        $format->set_align( 'center' );   #���ö��뷽ʽ���˴�Ϊ���У�

                #д��һ����ʽ���ͷǸ�ʽ�����ַ�����ʹ�����б�ʾ����
        my $col =my $row = 0;                  #�����к��е�λ��
        my $worksheet->write( $row, $col, 'Hi Excel!', $format );
        my $worksheet->write( 1, $col, 'Hi Excel!' );

        #ʹ��A1��ʾ��д��һ�����ֺ͹�ʽ
        my $worksheet->write( 'A3', 1.2345 );         #�ڵ����е�һ��д��һ������
        my $worksheet->write( 'A4', '=SIN(PI()/4)' ); #�ڵ����е�һ��д��һ����ʽ
#!/usr/bin/perl
 
# $a = 10;
# while( $a < 20 ){
   # if( $a == 15)
   # {
       # # ��������
       # $a = $a + 1;
       # next;
   # }
   # print "a ��ֵΪ: $a\n";
   # $a = $a + 1;
# }
