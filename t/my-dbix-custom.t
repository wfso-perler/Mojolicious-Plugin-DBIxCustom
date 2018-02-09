#!perl -T
use 5.10.1;
use strict;
use warnings;
use Test::More;

use Mojolicious;

use lib 't/lib';

BEGIN{
  use_ok( 'T::MyDBIxCustom' ) || print "Bail out!\n";
  use_ok( 'T::Model' ) || print "Bail out!\n";
  use_ok( 'T::Model::tmodel1' ) || print "Bail out!\n";
  use_ok( 'T::Model::tmodel2' ) || print "Bail out!\n";
  use_ok( 'T::Model::tmodel3' ) || print "Bail out!\n";
}

my $app = Mojolicious->new();

$app->plugin("DBIxCustom", {
    dsn             => "DBI:SQLite:dbname=:memory:",
    connector       => 1, ## 默认使用DBIx::Connector
    model_namespace => "T::Model",
    dbi_class       => "T::MyDBIxCustom"
  }
);



ok($app->dbi->isa("T::MyDBIxCustom"), "test-MyDBIxCustom");


done_testing;


