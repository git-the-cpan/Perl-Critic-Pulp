#!/usr/bin/perl

# 0-META-read.t -- check META.yml can be read by various YAML modules

# Copyright 2009 Kevin Ryde

# 0-META-read.t is shared among several distributions.
#
# 0-META-read.t is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation; either version 3, or (at your option) any later
# version.
#
# 0-META-read.t is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License along
# with this file.  If not, see <http://www.gnu.org/licenses/>.

use 5.000;
use strict;
use warnings;
use FindBin;
use File::Spec;
use Test::More;

# When some of META.yml is generated by explicit text in Makefile.PL it can
# be easy to make a mistake in the syntax, or indentation, etc, so the idea
# here is to check it's readable from some of the YAML readers.
#
# The various readers differ in how strictly they look at the syntax.
# There's no attempt here to say one of them is best or tightest or
# whatever, just see that they all work.
#
# See 0-Test-YAML-Meta.t for Test::YAML::Meta which looks into field
# contents, as well as maybe the YAML formatting.


my $meta_filename = File::Spec->catfile
  ($FindBin::Bin, File::Spec->updir, 'META.yml');
open META, $meta_filename
  or plan skip_all => "Cannot open $meta_filename ($!) -- assume this is a working directory not a dist";
close META or die;

plan tests => 6;

SKIP: { eval 'use Test::NoWarnings; 1'
          or skip 'Test::NoWarnings not available', 1; }

SKIP: {
  eval { require YAML; 1 }
    or skip "due to YAML module not available -- $@", 1;

  eval { YAML::LoadFile ($meta_filename) };
  is ($@, '',
      "Read $meta_filename with YAML module");
}

# YAML 0.68 is in fact YAML::Old, or something weird -- don't think they can
# load together
#
# SKIP: {
#   eval { require YAML::Old; 1 }
#     or skip 'due to YAML::Old not available -- $@', 1;
#
#   eval { YAML::Old::LoadFile ($meta_filename) };
#   is ($@, '',
#       "Read $meta_filename with YAML::Old");
# }

SKIP: {
  eval { require YAML::Syck; 1 }
    or skip "due to YAML::Syck not available -- $@", 1;

  eval { YAML::Syck::LoadFile ($meta_filename) };
  is ($@, '',
      "Read $meta_filename with YAML::Syck");
}

SKIP: {
  eval { require YAML::Tiny; 1 }
    or skip "due to YAML::Tiny not available -- $@", 1;

  eval { YAML::Tiny->read ($meta_filename) };
  is ($@, '',
      "Read $meta_filename with YAML::Tiny");
}

SKIP: {
  eval { require YAML::XS; 1 }
    or skip "due to YAML::XS not available -- $@", 1;

  eval { YAML::XS::LoadFile ($meta_filename) };
  is ($@, '',
      "Read $meta_filename with YAML::XS");
}

# Parse::CPAN::Meta describes itself for use on "typical" META.yml, so not
# sure if demanding it works will more exercise its subset of yaml than the
# correctness of our META.yml.  At any rate might like to know if it fails,
# so as to avoid tricky yaml for everyone's benefit, maybe.
#
SKIP: {
  eval { require Parse::CPAN::Meta; 1 }
    or skip "due to Parse::CPAN::Meta not available -- $@", 1;

  eval { Parse::CPAN::Meta::LoadFile ($meta_filename) };
  is ($@, '',
      "Read $meta_filename with Parse::CPAN::Meta");
}

# Data::YAML::Reader 0.06 doesn't like header "--- #YAML:1.0" with the #
# part produced by other YAML writers, so skip for now
#
# SKIP: {
#   eval { require Data::YAML::Reader; 1 }
#     or skip 'due to Data::YAML::Reader not available -- $@', 1;
#
#   my $reader = Data::YAML::Reader->new;
#   open my $fh, '<', $meta_filename
#     or die "Cannot open $meta_filename";
#   my $str = do { local $/=undef; <$fh> };
#   close $fh or die;
#
# #   if ($str !~ /\.\.\.$/) {
# #     $str .= "...";
# #   }
#   my @lines = split /\n/, $str;
#   push @lines, "...";
#    use Data::Dumper;
#    print Dumper(\@lines);
#
# #  { local $,="\n"; print @lines,"\n"; }
#
# @lines = (
#         '--- ',
#         '- one',
#         '-',
#         '  - two',
#         '  -',
#         '    - three',
#         '  - four',
#         '- five',
#         '... ',
#          );
#
#   eval { $reader->read (\@lines) };
#   is ($@, '',
#       "Read $meta_filename with Data::YAML::Reader");
# }

exit 0;
