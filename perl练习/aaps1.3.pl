#!usr/bin/perl


require 5.006;
use warnings;
use strict;
use Cwd;
use File::Basename;
use File::Spec qw(catfile catdir);
use vars qw($opt_d $opt_f $opt_c $opt_h);
use Getopt:: Std;


getopts('d:f:c:h');

#切换到工作目录执行： /home/cpauto/release
my $cdir = getcwd;
#编译的生成目录
my $to_base = '/home/gaps';
#增量编译打包目录
my $to_dir = '/home/cpauto/patch';

#set env 按照实际环境修改
$ENV{'HOME'} = '/home/gaps'
#......

# foreach my $key (sort keys %ENV)
# {
	# my $value = $ENV{$key};
	# print("ENV: $key, ----->,$value\n");
# }

if ($opt_h)
{
	&HelpMsg();
}
#变更依赖的配置文件读取
unless (($opt_c) and (-f $opt_c))
{
	print "参数 -c 为必选从那时，且必须存在\n";
	&HelpMsg();
}
my @cfg =();
my %socfg = ();
open(FILE,"<",$opt_c) 0r die "Can't open '$opt_c':$!"
while(FILE)
{
	my $tp =$_;
	$tp =~ s/^\s+|\s+$//g;
	next if($tp eq '');
	next if ($tp =~ m/^#/);
	if ($tp =~ m/:/)
	{
		my ($so1,$so2) = split(/:/,$tp);
		my @so2 = split(/,/,$so2);
		$socfg{$so1} = \@so2;
	}
	else
	{
		my @tplist = split(/,/,$tp);
		my $tpct = @tplist;
		if ($tpct >4)
		{
			push @cfg,$tp;
		}
	}
}
close FILE;

##
# print("############################\n");
# foreach my $key (sort keys %socfg)
# {
	# my @value = @{socfg{$key}};
	# print("so depend: $key ---> @value\n");
# }
# print("############################\n");

unless(($opt_d) and (-d $opt_d))
{
	print "参数 -d 为必选参数，且必须存在\n";
	&HelpMsg();
}


#读取变更清单
my @chfiles = ();
if (($opt_f) and (-f $opt_f))
{
	open (FILE,"<",$opt_f) or die "Can't open '$opt_f':$!";
	while(my $ff=<FILE>)
	{
		$ff =~ s/^\s+|\s+$//g;
		if ($ff !~ m/^#/)
		{
			push @chfiles,$ff;
		}
	}
	close FILE;
}
else
{
	my $version1 = &getwkversion($opt_d);
	print "svn locale version: $version1\n";
	@chfiles = &getchangelist($opt_d);
	my $version2 = &getwkversion($opt_d);
	print "svn new version: $version2\n";
}
unless (@chfiles)
{
	print("Changlist is null \n");
	exit 1;
}


$opt_d =~ s/\\/\//g;
$opt_d =~ s/\/$//g;

##get hash list
my %chdic =　();
for my $chf (@chfiles)
{
	my ($filename,$dirname,$suffix) = fileparse($chf);
	$dirname =~ s/\\/\//g;
	$dirname =~ s/\/$//g;
	$dirname =~ s/^\Q$opt_d\E//;
	$dirname =~ s/^\///;
	if (define($chdic{$dirname}))
	{
		$chdic{$dirname} = $chdic{$dirname}.",".$filename;
	}
	else
	{
		$chdic{$dirname} = $filename;
	}
}

#不建立时间目录
#my $out_path = File::Spec->catdir($to_dir,&tmdir());
my $out_payh =　$to_dir;
print("######################\n");
print "Release Path: $out_path \n";
system qq(rm -rf $out_path/*);
mkdir $out_path unless (-d $out_path);

#本次编译的so
my @build_so = ();
#本次编译的so 结果
my %build_result =();
#需要依赖的编译so
my @build_dep_so =();
my $count = 0;

foreach my $cfg (@cfg)
{
	my @cfglist = split(/,/.$cfg);
	my ($cf_dir,$cf_mk,$cf_from,$cf_to) = @cfglist[0..3];
	my @cf_so =();
	if ($#cfglist == 4)
	{
		push @cf_so,$cfglist[4];
	}
	else
	{
		@cf_so = @cfglist[4..$#cfglist];
	}
	# print("cfg value:$cf_dir,$cf_mk，$cf_from,$cf_to\n");
	# print("so path : @cf_so");
	my $ndir = File::Spec->catdir($cdir,$cf_dir);
	if (exists $chdic{$cf_dir})
	{
		if ($#cfglist == 4)
		{
			##dep add
			if (exists $socfg{$cf_so[0])
			{
				my $to_buildso = @{$socfg{$cf_so[0]}};
				push @build_dep_so,@to_buildso;
			}
			##dep add
			## mk my ($ndir,$cf_from,$cf_to,$so_name) = @_;
			&gen_mk($ndir,$cf_from,$cf_to,$cf_so[0]);
		}
		else
		{
			my @thischf = split(/,/,$chdic{$cf_dir});
			# print("find so fro file: $thischf\n");
			open(FILE,"<",$cf_mk) or die "Can't open '$cf_mk':$!"
			while(my $ff=<FILE>)
			{
				chomp($ff);
				if ($ff =~ m/(\S+):.*\Q$thischf\E/g)
				{
					push @allso,$1;
				}
			}
			close FILE;
			
		}
		foreach my $thisso (@cf_so)
		{
			if (grep {$_ eq $thisso} @allso)
			{
				##dep add
				if (exists $socfg{$thisso})
				{
					my  @to_buildso = @{$socfg{$thisso}};
					push @build_dep_so,@to_buildso;
				}
				&gen_mk($ndir,$cf_from,$cf_to,$thisso);
			}
		}
	}
	if ($count <1)
	{
		foreach my $nolist (@chfiles)
		{
			if ($nolist =~ m/^app\/hupp2\/cnaps2\/comm\/src\/cfg\.o$/g)
			{
				push @build_dep_so,"cnaps2_real";
				#........
				$count +=1;
			}
		}
	}
	###
	# print("to do sth else \n");
	# print("cfso : @cf_so \n");
	# print("build_dep_so : @build_dep_so \n");
	# print("build_so ： @build_so \n");
	foreach my $tpso ($cf_so)
	{
		if (grep {$_ eq $tpso} @build_dep_so)
		{
			unless (grep {$_ eq $tpso} @build_so)
			{
				print("Depend: To build $tpso\n");
				&gen_mk($ndir,$cf_from,$cf_to,$tpso);
			}
		}
	}
}


foreach my $chfiles (@chfiles)
{
	my ($filename,$dirname,$suffix) = fileparse($chfiles);
	chdir $cdir;
	my $file15 = File::Spec->catdir("home","cpauto","release",$chfiles);
	my $file10 = File::Spec->catdir($to_dir,$dirname);
	if($chfiles =~ m/^tamcx\//g || $$chfiles =~ m/^cfg\//g) 
	{
		if (! -d $file10)
		{
			system qq(mkdir -p $file10);
			print("mkdir $file10\n");
		}
		system qq(cp $chfiles $file10);
		print("copy from $chfiles to $file10\n");
	}
	#..............
}



print("ChangeSet List: \n");
print join "\n",@chfiles;
print("\nThis Release Build : \n");
foreach my $key (keys %build_result)
{
	my $value = $build_result{$key};
	print("Build Result: $key ---> $value\n");
}

sub gen_mk()
{
	my ($ndir,$cf_from,$cf_to,$so_name) = @_;
	print("Change directory to :$ndir ,To Build :$so_name\n");
	chdic $ndir;
	my $nndir = getcwd;
	my $file1 =File::Spec->catfile($to_base,$cf_from,$so_name);
	unlink $file1 if (-e $file1);
	my $file2 =File::Spec->catfile($out_path,$cf_to);
	my $cmd1 ="gapsmake clean";
	my $cmd2 = "gapsmake $so_name";
	print("###################################","\n");
	print("Current dir, $nndir\n");
	print("Start build for: $so_name","\n");
	&runmake($cmd1);
	my $out = &runmake($cmd2);
	##
	push @build_so,$so_name;
	$build_result{$so_name} = $out;
	##
	# print("cmd: $cmd1,$cmd2\n");
	# print("$cmd_res1,$cmd_res2\n");
	system qq(mkdir -p $file2) unless (-d $file2);
	print("copy from $file1 to $file2 \n");
	system qq(cp $file1 $file2);
	print('End build',"\n");
	print("End build","\n");
	print("##################################","\n");
}

sub runmake()
{
	my $cmd =shift;
	print("Run gmk cmd: $cmd\n");
	print("***********************\n");
	my $out = system($cmd);
	#print("run result: $cmd_res[-1]\n");
	print("***********************\n");
	if ($out !=0)
	{
		print("Run gmk failed,Unix Signal: $out\n");
		print("exit 1\n");
		$out = "Failde";
		#exit 1;
	}
	else
	{
		print("Run gmk pass. \n");
		$out = "Pass";
	}
	return $out;
}

sub getwkversion()
{
	my $wk =shift;
	my $ver = qx(svn info --username 180048 --password nbcb,111 "$opt_d"|grep Revision);
	$ver =~ /(\d+)/;
	return $1;
}

sub getchangelist()
{
	my $wk = shift;
	my @ver = qx(svn up --force --username 180048 --password nbcb,111 "opt_d");
	my @chlist =();
	foreach my $info (@ver)
	{
		$info =~ s/^\s+|\s+$//g;
		if ($info =~ m/^(U|A)\s+(.*)$/)
		{
			my $ff =$2;
			next if (-d $ff);
			push @chlist,$2;
		}
	}
	return @chlist;
}

sub tmdir()
{
	my ($sec,$min,$hour,$day,$mon,$year,$wday,$yday,$isdst) = localtime(time);
	$sec = ($sec < 10)? "0$sec":$sec;
	$min = ($min < 10)? "0$min":$min;
	$hour = ($hour < 10)? "0$hour":$hour;
	$day = ($day < 10)? "0$day":$day;
	$mon = ($mon < 9)? "0".($mon+1):($mon+1);
	$year += 1900;
	my $now = "$year$mon$day$hour$min";
	return $now;
	
}

sub inarray()
{
	(my $tp1,my @arr) = @_;
	if (grep {$_ eq $tp1} @arr)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

sub tmc()
{
	my ($sec,$min,$hour,$day,$mon,$year,$wday,$yday,$isdst) = localtime(time);
	$sec = ($sec < 10)? "0$sec":$sec;
	$min = ($min < 10)? "0$min":$min;
	$hour = ($hour < 10)? "0$hour":$hour;
	$day = ($day < 10)? "0$day":$day;
	$mon = ($mon < 9)? "0".($mon+1):($mon+1);
	$year += 1900;
	my $now = "$year-$mon-$day $hour:$min:$sec";
	return $now;
}

sub HelpMsg()
{
	print "Option: -d: local svn workspace \n";
	print "Option: -f: changeser file \n";
	print "Option: -c: makefile cfg file \n";
	print "For example : perl $0 -d /home/xx/svn_view -f ff.txt -c yl.cfg\n";
	exit 1;
}