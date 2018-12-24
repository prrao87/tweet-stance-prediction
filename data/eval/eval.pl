#!/usr/bin/perl

##########################################
#This script is originally created to evaluate Semeval-2016 Task 6:
#Detecting Stance in Tweets
#http://alt.qcri.org/semeval2016/task6/
#
#Author: Xiaodan Zhu (www.xiaodanzhu.com)
#
#Created date: Oct. 1, 2015
#
#This simple script is free but if you choose to modify it
#please include the description above.
##########################################

##########################################
#For usage, type perl eval.pl -u
##########################################

use strict;

if(@ARGV == 1 && $ARGV[0] eq "-u"){
	printUsage();
	die "\n";
}

if(@ARGV != 2){
	print STDERR "\nError: Number of parameters are incorrect!\n";
	printUsage();
	die "\n";
}

my $fnGold = $ARGV[0];
open(IN, $fnGold) || die "Error: Cannot open the gold-standard file.\n";
my @goldLns = <IN>;
chomp @goldLns;
close(IN);

my $fnGuess = $ARGV[1];
open(IN, $fnGuess) || die "Error: Cannot open the file containing your prediction.\n";
my @guessLns = <IN>;
chomp @guessLns;
close(IN);

if(@guessLns != @goldLns){
	print STDERR "\nError: make sure the number of lines in your prediction file is same as that in the gold-standard file!\n";
	print STDERR sprintf("The gold-standard file contains %d lines, but the prediction file contains %d lines.\n", scalar(@goldLns), scalar(@guessLns));
	die "\n";
}

my @cats = ("FAVOR", "AGAINST", "NONE", "UNKNOWN");
my %catsHash = map{$_ => 1}@cats;
my %numOfTruePosOfEachCat = ();
my %numOfGuessOfEachCat = ();
my %numOfGoldOfEachCat = ();

for (my $i = 0; $i < @guessLns; $i+=1) {
	my $guessLn = $guessLns[$i];
	$guessLn =~ s/\r//g;
	my $goldLn = $goldLns[$i];
	$goldLn =~ s/\r//g;

	if($goldLn eq "ID	Target	Tweet	Stance"){
		next;
	}

	my @goldArr = split(/\t/, $goldLn);
	if(@goldArr != 4){
		print STDERR sprintf("\nError: the following line in the gold-standard file does not have a correct format:\n\n%s\n\n",$goldLn);
		print STDERR "Correct format: ID<Tab>Target<Tab>Tweet<Tab>Stance\n";
		die "\n";
	}

	my @guessArr = split(/\t/, $guessLn);
	if(@guessArr != 4){
		print STDERR sprintf("\nError: the following line in your prediction file does not have a correct format:\n\n%s\n\n",$guessLn);
		print STDERR "Correct format: ID<Tab>Target<Tab>Tweet<Tab>Stance";
		die "\n";
	}


	my $guessLbl = $guessArr[3];
	my $goldLbl = $goldArr[3];

	if(!defined($catsHash{$goldLbl})){
		print STDERR sprintf("\nError: the stance label \"%s\" in the following line of the gold-standard file is invalid:\n\n%s\n\n",$goldLbl, $goldLn);
		print STDERR "Correct labels in gold-standard file can be: FAVOR, AGAINST, NONE, or UNKNOWN (case sensitive). \n";
		die "\n";
	}

	if(!defined($catsHash{$guessLbl})){
		print STDERR sprintf("\nError: the stance label \"%s\" in the following line of the prediction file is invalid:\n\n%s\n\n",$guessLbl, $guessLn);
		print STDERR "Correct labels in predication file can be: FAVOR, AGAINST, NONE, or UNKNOWN (case sensitive). \n";
		die "\n";
	}



	$numOfGoldOfEachCat{$goldLbl} += 1;
	$numOfGuessOfEachCat{$guessLbl} += 1;
	if($guessLbl eq $goldLbl){
		$numOfTruePosOfEachCat{$guessLbl} += 1;
	}

}


#compute precision, recall, and f-score
my %precByCat = ();
my %recallByCat = ();
my %fByCat = ();
my $macroF = 0.0;


foreach my $cat (@cats) {
	my $nTp = $numOfTruePosOfEachCat{$cat};
	my $nGuess = $numOfGuessOfEachCat{$cat};
	my $nGold = $numOfGoldOfEachCat{$cat};

	my $p = 0;
	my $r = 0;
	my $f = 0;

	$p = $nTp/$nGuess if($nGuess != 0);
	$r = $nTp/$nGold if($nGold != 0);
	$f = 2*$p*$r/($p+$r) if($p + $r != 0);

	$precByCat{$cat} = $p;
	$recallByCat{$cat} = $r;
	$fByCat{$cat} = $f;
}

#print results
my $macroF = 0.0;
print STDOUT sprintf("\n\n============\n");
print STDOUT sprintf("Results				 \n");
print STDOUT sprintf("============\n");
my $nCat = 0;
foreach my $cat (@cats) {
	if($cat eq "FAVOR" || $cat eq "AGAINST"){
		$nCat += 1;
		$macroF += $fByCat{$cat};
		print STDOUT sprintf("%-9s precision: %.4f recall: %.4f f-score: %.4f\n", $cat, $precByCat{$cat}, $recallByCat{$cat}, $fByCat{$cat});
	}
	
}
$macroF = $macroF/$nCat;
print STDOUT sprintf("------------\n");
print STDOUT sprintf("Macro F: %.4f\n\n", $macroF);


sub printUsage {
	print STDERR "\n---------------------------\n";
	print STDERR "Usage:\nperl eval.pl goldFile guessFile\n\n";
	print STDERR "goldFile:  file containing gold standards;\nguessFile: file containing your prediction.\n\n";
	print STDERR "These two files have the same format:\n";
	print STDERR "ID<Tab>Target<Tab>Tweet<Tab>Stance\n";
	print STDERR "Only stance labels may be different between them!\n";
	print STDERR "---------------------------\n";
}
