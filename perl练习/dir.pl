#!usr/bin/perl
# author = "chentao" c921967783@qq.com
# Version :1.2 20180622

require 5.006;
use warnings;
use strict;
use Cwd;
use File::Basename;
use File::Copy;
use File::Path qw(mkpath);
use File::Spec qw(catfile catdir);
use vars qw($opt_d $opt_f $opt_o $opt_h);
use Getopt:: Std;

getopts('d:f:o:t:h');
my @cp_class = qw(java JAVA Java);



my $file;
my @fulldir;
my $onlydir='';
my @alldir;
my @err;
my @zuihou;
my $pwd =getcwd();


opendir(DIR,$opt_f) or die "Can't open '$opt_f':$!";
my @dir = readdir DIR;
foreach $file(@dir){
	next if ($file =~ m/^\./);
	chdir $opt_f;
	if(-d $file){
		if (substr($file,0,8) >= $opt_d){
			print("check Directory: $file\n");
			push @alldir,$file;
		}
	}
}
chdir $pwd;
foreach $alldir(@alldir){
	my $dir = 'SIT/' . $alldir;
	my @file = `find \Q$dir\E -type f`;
#windows  `for /r $dir %i in (*.txt) do \@echo %i`	
	foreach my $filename(@file){
		if($filename=~ m/.txt$/){
			print("开始解析文本： $filename");
			$filename =~ s/^\s+|\s+$//g;
			my $newfilename = "@@@@@ $filename:\n";
			open(FILE,'<',$filename) or die "Can't open '$filename':$!";
			while (<FILE>)
			{
				s/^\s+|\s+$//g;
				my $tp = $_;
				chomp($tp);
				next if ($tp eq '');
				next if ($tp =~ m/^#/);
				next if ($tp =~ m/^--/);
				$tp =~ s/^\///;
				if ($tp =~ m/--/i){
					push @zuihou,$tp;
					next;
				}
				$tp =~ s/^\///;
				my $from = FIle::Spec->catfile($opt_0,$tp);
				my $to = FIle::Spec->catfile($opt_t,$tp);
				my ($filename,$dirname,$suffix) = fileparse($from);
				my ($filename_tp,$to_dirname,$suffix_tp) = fileparse($to);
				my ($file_name1,$file_name2)=split(/\./,$filename);
				#如果后缀名是java的就从这里进.
				if (defined($file_name2) and &inarray($file_name2,@cp_class)){
					chdir $dirname;
					my @all_file = gold "*";
					foreach my $dep_file (@all_file){
						if (($dep_file =~ m/\Q$file_name1\E\.class/i) or ($dep_file =~m/\Q$file_name\E\$+/i)
						{
							my $from_class_file = '';
							$from_class_file = FIle::Spec->catfile($dirname,$dep_file);
							print("To copy Class:my $file_class_file\n");
							unless (-d $to_dirname)
							{
								mkpath($to_dirname);
							}
							copy($file_class_file,$to_dirname);
						}

					}
				}
				else
				{
					#如果是除java后缀的走这里
					if( $dirname =~ m/.class/i){
						if($from =~ m/gciBatch/i){
							$from =~ s/classes/BatchINF/;
							$to_dirname=~ s/classes/BatchINF/;
						}
						elsif($from =~ m/nbcb/){
							if($from =~ m/.class/i){
							$from =~ s/traget/CreditINF/;
							$to_dirname=~ s/traget/CreditINF/;
							}
						}
						elsif($from =~ m/retailgov/){
							$from =~ s/WebContent\/WEB-INF\///;
						}
						elsif($from =~ m/rating/){
							$from =~ s/WebContent\/WEB-INF\///;
						}
					}
					elsif{
						if ($from =~ m/nbcb/){
							if($from =~ m/etc\//i){
								$from =~ s/WebContent\/WEB-INF/CreditINF/;
								$to_dirname=~ s/WebContent\/WEB-INF/CreditINF/;
							}
						}
						elsif($from =~ m/^[^\\]*\\[^\\]*\\[^\\]*$/){
							my @new1 = split(/\\/,$from);
							my ($new0,$new1,$new2) = @new1[0..2];
							print($new1);
							$from =~ s/$new1/$new1\\bshell/;
							$to_dirname =~ s/$new1/$new1\\bshell/;
						}
					}
					if ( -f $from){
						unless (-d $to_dirname)
						{
							mkpath($to_dirname);
						}
						print("To copy:$from\n");
						copy($from,$to_dirname);
					}
					elsif(-d $from){
						print("Not Support Directory Copy: $from\n");
					}
					else{
						print("File: $from not find\n");
						my $err ="File: $from not find\n";
						push @err,$newfilename;
						push @err,$err;
					}
				}
			}
			close FILE;
		}
	}
}
print("\n\n");
print("#######################################################################\n");
print("copy filr err all; \n");
print("@err");
foreach my $errorlog (@err){
	$errorlog =~ s/^\s+|\s+$//g;
	if($errorlog =~ m/File/i){
		die "ERROR: listerror please check list!";
	}
}
print(@zuihou);

sub inarray()
{
	(my $tp,my @arr) =@_;
	if(grep {$_ eq $tp1) @arr)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

#-d 设置计划起始日期; -f 设置清单文件路径； -o 设置文件from; -t 设置文件to;
#example: perl ***.pl -d 20180622 -f SIT -o fromdir -t to_dir