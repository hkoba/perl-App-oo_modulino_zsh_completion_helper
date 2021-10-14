#!/usr/bin/env perl
use strict;
use Test::More 0.98;

use FindBin;
use lib "$FindBin::Bin/../lib";

use File::Spec;

(my $testDir = File::Spec->rel2abs(__FILE__)) =~ s/\.t$/.d/;

use_ok $_ for qw(
    App::oo_modulino_zsh_completion_helper
);

is_deeply(
  [App::oo_modulino_zsh_completion_helper->find_package_from_pm("$testDir/Baz.pm")],
  [
    qw(Foo::Bar::Baz),
    "$testDir/lib",
    1
 ], "find_package_from_pm should resolve symlink"
);


done_testing;

