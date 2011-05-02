#!/usr/bin/perl -w

# Copyright 2009, 2010, 2011 Kevin Ryde

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

use 5.005;
use strict;
use warnings;
use Perl6::Slurp;

use lib::abs '.';
use MyLocatePerl;
use MyStuff;
use Text::Tabs ();

my $verbose = 0;

my $l = MyLocatePerl->new;
while (my ($filename, $str) = $l->next) {
  if ($verbose) { print "look at $filename\n"; }

  if ($str =~ /^__END__/m) {
    substr ($str, $-[0], length($str), '');
  }

  # strip comments
  #  $str =~ s/#.*//mg;

  # while ($str =~ /(?:^|\G|[^\\])  # current pos or not a \
  #                 \\(?:\\\\)*     # odd number of \
  #                 # and an unknown
  #                 # ([cdghijkmopqsvwyzABCDFGHIJKMNOPRSTVWXYZ456789])
  #                 \n
  #                /sgx) {
  #
  # while ($str =~ /\G[$@]\w+
  #                 (?:::\w+)*
  #                 \\(:)
  #                /sgx) {


  # \-> \[ \{
  while ($str =~ /(\\*)
                  [\$\@]\w+
                  (?:::\w+)*
                  \\([[{-])
                 /sgx) {
    next if length($1) & 1;

    my $char = $2;
    my $pos = pos($str);

    my ($line, $col) = MyStuff::pos_to_line_and_column ($str, $pos);
    my $s = MyStuff::line_at_pos($str, $pos);

    substr($s,0,$col) =~ /q[qx]|"/ or next;

    print "$filename:$line:$col: unknown \\$char\n$s";
  }
}

exit 0;
