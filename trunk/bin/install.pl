#!/usr/bin/perl
print "Thank you for downloading the AVO Earthquake Review Workspace
The purpose of this workspace is to give all analysts and research
scientists working with AVO data a common configuration of velocity
model, regions, and magnitude algorithms to work with.

If you have questions, contact Glenn Thompson (gthompson@alaska.edu)
Better still, post a message to the corresponding Google Group
or report issues/bugs through the Google Code project page";
use Env;
print "\nMenu:\n";
@OPTIONS=qw(Install Update Quit);
$count = 0;
while ($menuitem = shift @OPTIONS) {
	print ++$count."  ".$menuitem."\n";
}
$answer = <STDIN>;
&install if ($answer==1);
&update if ($answer==2);

sub install {
	
	# record the current directory - the AVO WORKSPACE directory
	$AVO_WS=`pwd`;chomp($AVO_WS);
	print "Current directory is $AVO_WS\n";

	# Build the avows bashrc file
	$avowsrc="$AVO_WS/rc/bashrc_avows";
	print "The AVO Workspace bashrc file is $avowsrc\n";
	open(FOUT,">$avowsrc");
	print FOUT "export VELOCITY_MODEL_DATABASE=$AVO_WS/genloc/db/vmodel\n";
	print FOUT "export PFPATH=\$PFPATH:$AVO_WS/pf\n";
	print FOUT "export PATH=$AVO_WS/bin:\$PATH\n";
	close FOUT;

	# Add it to the .bashrc file
	$bashrc=$ENV{HOME}."/.bashrc";
	$alias="alias avo_ws=\"cd $AVO_WS;source $avowsrc\"";
	if ( -e $bashrc) {
		print "$bashrc already exists\n";
		# Check if line already exists
		$result=`grep avo-earthquake-review-workspace $bashrc | wc -l`;chomp($result);
		if ($result==0) {
			print "appending\n";
			open(FAPP,">>$bashrc");
			print FAPP "$alias\n";
			close FAPP;
		} else {
			print "alias for avo_ws already exists in $bashrc\n";
		}
	} else {
		print "$bashrc does not exist: creating\n";
		system("echo $alias >> $bashrc");
	}

	# use the .dbpickrc file supplied
	system("cp rc/dbpickrc .dbpickrc");

	print "\nThe install was successful.\n"; 
	print "\nTo use the AVO earthquake review workspace type:
	   avo_ws\nfrom any new terminal window\n";
}
sub update {
}
