#!/usr/bin/perl
# AoC day 06 star 1 - tuning trouble

use strict;
use warnings;

# test examples are short and multiple, so today we embed them here:
sub getdummy{
  my ($nd)=@_; # call arg num switches between given dummies.
  my @test; # list of example strings with known result.
  my @res; # expected results.
  $test[0]="mjqjpqmgbljsphdztnvjfqwrcgsmlb"; $res[0]=7;
  $test[1]="bvwbjplbgvbhsrlpgdmjqwftvncz"; $res[1]=5;
  $test[2]="nppdvjthqldpwncqszvftbrmjlhg"; $res[2]=6;
  $test[3]="nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"; $res[3]=10;
  $test[4]="zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"; $res[4]=11;
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

# logic:
# try at each pos:
# - char in 1st pos does not repeat in 2nd to 4th. plus:
# - char in 2nd pos does not repeat in 3rd or 4th. plus:
# - char in 3rd pos does not repeat in 4th. 
# if all fulfilled, we have 4 different chars
sub isValidMarker{
  my ($s)=@_;
  if($s=~m/^(.)(?:(?!\1).){3}/){ # char 1 not repeated in char 2..4?
    if($s=~m/^.(.)(?:(?!\1).){2}/){ # char 2 not repeated in char 3..4?
      if($s=~m/^..(.)(?:(?!\1).)/){ # char 3 not repeated in char 4?
        return 1;
      }
    }
  }
  return 0;
}

my $s=getread(1); # or getdummy for testing.
# decompose into substrings and test each, end at first match.
my $ssl=4; # substring length
my $ll=length($s);
# eat away from left and report first found:
my $i=0; # offset.
while($i<$ll){
  my $x=substr($s,$i,$ssl);
  print "checking $ssl-char substring starting at offset $i := $x --> ";
  if(isValidMarker($x)){
    print "yes!\nstart found after reading ".($i+$ssl)." chars.\n";last;
  }else{print "notyet.\n";}
  $i++;
}

