#!/usr/bin/perl -w

# Copyright 2009, 2010, 2012, 2014 Kevin Ryde

# This file is part of Perl-Critic-Pulp.
#
# Perl-Critic-Pulp is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published
# by the Free Software Foundation; either version 3, or (at your option) any
# later version.
#
# Perl-Critic-Pulp is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
# Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with Perl-Critic-Pulp.  If not, see <http://www.gnu.org/licenses/>.


# Grep for =begin not followed by newline, ie. multi-line command

use 5.005;
use strict;
use warnings;
use Perl6::Slurp;

use lib::abs '.';
use MyLocatePerl;
use MyStuff;

my $verbose = 0;

my $l = MyLocatePerl->new (exclude_t => 1,
                           include_pod => 1);
while (my ($filename, $str) = $l->next) {
  if ($verbose) { print "look at $filename\n"; }
  $str =~ tr/\r//d; # new CRs

  while ($str =~ /(^|\n)(=begin[^\n]*\n[^\n]+)/sg) {
    my $pos = $-[0];
    my $lines = $2;
    my $lastchar = ord(substr($lines,-1,1));

    my ($line, $col) = MyStuff::pos_to_line_and_column ($str, $pos);
    print "$filename:$line:$col: char=$lastchar\n$lines\n";
  }
}

exit 0;

=pod

=begin comment
blah

=end comment

=cut
