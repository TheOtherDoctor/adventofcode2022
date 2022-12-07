#!/usr/bin/perl
# AoC day 06 star 2 - tuning trouble

use strict;
use warnings;

# test examples are short and multiple, so today we embed them here:
sub getdummy{
  my ($nd)=@_; # call arg num switches between given dummies.
  my @test; # list of example strings with known result.
  my @res; # expected results.
  $test[0]="mjqjpqmgbljsphdztnvjfqwrcgsmlb"; $res[0]=19;
  $test[1]="bvwbjplbgvbhsrlpgdmjqwftvncz"; $res[1]=23;
  $test[2]="nppdvjthqldpwncqszvftbrmjlhg"; $res[2]=23;
  $test[3]="nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"; $res[3]=29;
  $test[4]="zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"; $res[4]=26;
  print "correct result for this example should be $res[$nd]\n";
  return $test[$nd];
}

# read from file. ignores call args.
sub getread{
  open(FH,"input") or die "filefail.";
  my $s=<FH>; chomp($s);
  close(FH);
  return $s;
}

# try at each pos if char in Nth pos does not repeat in (N+1)th to last;
# if all fulfilled, we have all chars different.
sub allCharsDiffer{
  my ($s)=@_;
  my $lc=length($s)-1; # length of check zone.
  # comparing 1st char to chars 2..end.
  # start with full given string, and shorten after each match
  # if any level is not matched, this candidate is out.
  while($s){ # just do as long as something to do. recursion? well, meh.
    if($s=~m/^(.)(?:(?!\1).){$lc}/){ # char 1 not repeated in rest?
      # shorten string and check zone and loop on if needed:
      $s=substr($s,1,$lc); $lc--;
      if($lc<1){return 1;} # single char left - nothing to check. gotcha.
      #dbg# print "ok to go for lc=$lc s='$s'.";
    }else{return 0;}
  }
  die "I should better not be here.";
}

my $s=getread(4); # or getdummy for testing.
# decompose into substrings and test each, end at first match.
my $ssl=14; # substring length
my $ll=length($s);
# eat away from left and report first found:
my $i=0; # offset.
while($i<$ll){
  my $x=substr($s,$i,$ssl);
  print "checking $ssl-char substring starting at offset $i := $x --> ";
  if(allCharsDiffer($x)){
    print "yes!\nstart found after reading ".($i+$ssl)." chars.\n";last;
  }else{print "notyet.\n";}
  $i++;
}

