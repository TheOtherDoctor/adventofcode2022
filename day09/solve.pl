#!/usr/bin/perl
# AoC day 09 star 1 - rope ends 

# concept notes: we do not need a matrix here, just differences
# between the two ends.


use strict;
use warnings;

# head and tail both start at 0/0:
my %H=( x => 0, y => 0 );
my %T=( x => 0, y => 0 );
# unique storage for tail positions:
my %tailpos; 

my $testdummy=0; # opmode for testing

# set first marker for initial tail pos:
my $ts=getPosStr(\%T);
print "T now at $ts\n";
$tailpos{$ts}=1; 

if($testdummy){
  updateActionHead("U 3"); 
  updateActionHead("R 2"); 
  updateActionHead("D 1"); 
  updateActionHead("L 7"); 
  updateActionHead("R 4"); 
  reportTailTrackCount(\%tailpos);
  exit(0);
}
 
my $pcmds=initReadCommands("input");
$ts=getPosStr(\%T);
$tailpos{$ts}=1;
while(@{$pcmds}){
  my $cmd=shift(@{$pcmds});
  updateActionHead($cmd); # triggers also the tail update and marker.
  print "now: H at ".getPosStr(\%H)." and T at ".getPosStr(\%T)."\n";
}
reportTailTrackCount(\%tailpos);

exit(0);

# ---- subs ----

sub initReadCommands{
  my ($fn)=@_;
  my $pcmds=();
  open(FH,"$fn") or die "filefail.\n";
  while(<FH>){
    chomp();
    if(m/^[RLUD] (\d+)$/){
      push(@{$pcmds},$_);
    }else{
      die "command weirdo.";
    }
  }
  close(FH);
  return $pcmds;
}

sub getPosStr{
  my ($t)=@_;
  my $s="x=".$t->{x}.";y=".$t->{y};
  return $s;
}

sub updateActionHead{
  my ($cmd)=@_;
  # parse command and change head:
  if($cmd=~m/([UDLR]) (\d+)$/){
    my $dir=$1; 
    my $dist=$2;
    print "moving $dist in dir $dir.\n";
    my $key;
    # dist is always >0, else dir useless.
    # move one by one.
       if($dir eq "U"){ for my $i (1..$dist){ $H{y}++; updateFollowTail(); }}
    elsif($dir eq "D"){ for my $i (1..$dist){ $H{y}--; updateFollowTail(); }}
    elsif($dir eq "R"){ for my $i (1..$dist){ $H{x}++; updateFollowTail(); }}
    elsif($dir eq "L"){ for my $i (1..$dist){ $H{x}--; updateFollowTail(); }}
    else { die "oops."; }
  }else { die "oops."; }
}

sub updateFollowTail{
  my $dx=$H{x}-$T{x}; if(abs($dx)>2){ die "dx>2 ?!?"; }
  my $dy=$H{y}-$T{y}; if(abs($dy)>2){ die "dy>2 ?!?"; }
  # primary check is to find a direction in which the diff
  # if >1. if found, go one(!) step into that dir. 
  if($dx>1){ $T{x}++; if($dy!=0){ $T{y}+=$dy; } }
  if($dx<-1){ $T{x}--; if($dy!=0){ $T{y}+=$dy; } }
  if($dy>1){ $T{y}++; if($dx!=0){ $T{x}+=$dx; } }
  if($dy<-1){ $T{y}--; if($dx!=0){ $T{x}+=$dx; } }
  # once a primary diff is found, it is possible that we also 
  # have an offset in the other direction, but that cannot
  # be bigger than 1 (algo asserts that), so we can just 
  # add that signed value above.
  my $ts=getPosStr(\%T);
  print "H now at ".getPosStr(\%H)." -> T now at $ts\n";
  $tailpos{$ts}=1; # set marker into hash.
}

sub reportTailTrackCount{
  my $sum=0;
  for my $v (values(%tailpos)){
    $sum+=$v; # ... or use map() oneliner. ;-)
  }
  print "tail has visited $sum positions\n";
}

