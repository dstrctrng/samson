#!/usr/bin/env perl

use IO::File;
use strict;
use Data::Dumper;

local $/ = undef; 

my $secret=<>; $secret =~ s{\s*$}{};

open FH, "<$ARGV[0]";

my $env = <FH>;

$env =~ s{\{bundle exec rake secret\}}{$secret}se;

print $env;
