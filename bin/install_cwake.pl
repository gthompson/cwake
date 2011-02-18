#!/usr/bin/perl
print<<EOF;

*** Welcome to the install script for CWAKE ***

This workspace provides a common configuration of tool settings,
velocity models, and magnitude algorithms suitable for working 
with waveform and catalog data from the Alaska Volcano Observatory.

Post questions to: Glenn Thompson (gthompson "at" alaska.edu); the 
corresponding Google Group; or the issues page of Google Code project.

It is recommended that you select "y" in answer to all the questions
that will be asked as you go through this installer. 

NOTE: YOU WILL BE ASKED IF YOU WANT THIS SCRIPT TO ADD A LINE TO YOUR
\$SHELLrc FILE.

EOF

use Env;
print "\nMenu:\n";
@OPTIONS=qw(Install Quit);
$count = 0;
while ($menuitem = shift @OPTIONS) {
	print ++$count."  ".$menuitem."\n";
}
$answer = <STDIN>;
&install if ($answer==1);



	
sub install {
	
	# record the current directory - the CWAKE directory
	use File::Basename qw(dirname);
	$CWAKE = dirname(dirname $0);
	chdir($CWAKE);
	$CWAKE=`pwd`;chomp($CWAKE);
	print "Current directory is $CWAKE\n";
	
	# get shell
	$shell = $ENV{SHELL};
	$shell=&choose_shell() if (&yn("You are using $SHELL. Is this the Unix shell you want to use for the CWAKE"));

	if ($shell eq "/bin/bash") {
		$sh = "bash";
		$command = "export";
	} elsif ($shell eq "/bin/csh") {
		$sh = "csh";
		$command = "setenv";
	} elsif ($shell eq "bin/tcsh") {
		$sh = "tcsh";
		$command = "setenv";
	} # endif $shell

	if ($sh) {	

		# Build the avo rc file
		$avowsrc="$CWAKE/rc/cwake.rc";
		print "The CWAKE bashrc file is $avowsrc\n";
		open(FOUT,">$avowsrc");
		print FOUT "$command VELOCITY_MODEL_DATABASE=vmodel_avo\n";
		print FOUT "$command DATAPATH=\$DATAPATH:$CWAKE\n";
		print FOUT "$command PFPATH=\$PFPATH:$CWAKE/pf\n";
		print FOUT "$command PATH=$CWAKE/bin:\$PATH\n";
		close FOUT;

		# Add it to the .$shrc file
		$shellrc=$ENV{HOME}."/.".$sh."rc";
		$alias="alias cwake=\"cd $CWAKE;source $avowsrc\"";

		if ( -e $shellrc) {
			print "$shellrc already exists\n";
			# Check if line already exists
			#$result=`grep $CWAKE $shellrc | wc -l`;chomp($result);

			#if ($result==0) {

				if (&yn("Would you like an alias 'cwake' to be added to $shellrc file so that you can switch to the workspace whenever you like")) {
					print "OK. Nothing added to $shellrc. But you may want to use this alias in future:\n   $alias\n";
				} else { 
					print "appending alias 'cwake' to $shellrc\n";
					open(FAPP,">>$shellrc");
					print FAPP "$alias\n";
					close FAPP;
				}

			#} else {
				#print "the alias 'cwake' already exists in $shellrc. Nothing added.\n";
			#} #endif $result==0

		} # endif (-e $shellrc)
	} else {
		print "Sorry, there is no installer for your *nix shell $shell\n";
	} # endif ($sh)
	
	# use the .dbpickrc file supplied
	print "Copying $CWAKE/rc/dbpickrc to $CWAKE/.dbpickrc\n";
	system("cp $CWAKE/rc/dbpickrc $CWAKE/.dbpickrc");

	# Summary
	print "\nThe install was successful.\n"; 
	print "\nTo use CWAKE type:\n   cwake\nfrom any new terminal window\n";
	print "\nIt is recommended that you work from $CWAKE whenever you use CWAKE. Otherwise, you may want to copy $CWAKE/.dbpickrc to the directory you will be working from\n";

} # end sub install


sub yn {
	$question = $_[0];
	print "\n$question (y/n)?\n";
	$ans = <STDIN>;
	if (!($ans=~/^[yY]/)) { 
		return 1; # No
	} else {
		return 0; # Yes
	}
}

sub choose_shell {
	print "SCAFFOLD: need to write choose_shell subroutine\n";
}
