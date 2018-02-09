#!perl -T
use 5.10.1;
use strict;
use warnings;
use Test::More;

use Mojolicious;
use Data::Dumper;

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

$app->dbi->execute("CREATE TABLE `tmodel3` (
  test_id int NOT NULL ,
  test_name varchar(255) NOT NULL,
  test_intro varchar(255) NOT NULL,
  create_time datetime NOT NULL,
  update_time datetime NOT NULL,
  is_deleted tinyint(4) NOT NULL DEFAULT '0',
  primary key(test_id,test_name)
)");

my $tm3 = $app->model("tmodel3");
my $t1 = $tm3->create({
    test_name  => "a",
    test_intro => "b",
    test_id    => 1
  }
);
my $t1_str = Dumper($t1);
ok($t1->{$tm3->name}->{test_id} eq "1", "tmodel1 create " . $t1_str);
ok($t1->{$tm3->name}->{test_name} eq "a", "tmodel1 create " . $t1_str);
ok($t1->{$tm3->name}->{test_intro} eq "b", "tmodel1 create " . $t1_str);
ok($t1->{object}->{is_deleted} eq "0", "tmodel1 create " . $t1_str);

my $t2 = {
  test_name  => "ab",
  test_intro => "ba"
};

my $tt = {%{$t1->{$tm3->name}}, %{$t2}};
sleep 1;
my $t3 = $tm3->edit($tt, $t1->{$tm3->name});

my $t4 = $tm3->get_by_id($tt->{test_id}, $tt->{test_name});

my $t3_str = Dumper($t3);
my $t4_str = Dumper($t4);

ok($t3->{$tm3->name}->{test_id} eq "1", "tmodel1 edit " . $t3_str);
ok($t3->{$tm3->name}->{test_name} eq "a", "tmodel1 edit " . $t3_str);
ok($t3->{$tm3->name}->{test_intro} eq "ba", "tmodel1 edit " . $t3_str);
ok($t4->{object}->{update_time} gt $t1->{object}->{update_time}, $t4_str . "\n" . $t1_str);
ok($t3->{object}->{is_deleted} eq "0", "tmodel1 edit" . $t3_str);

$tm3->sremove_by_id($tt->{test_id}, $tt->{test_name});

my $t5 = $tm3->get_by_id($tt->{test_id}, $tt->{test_name});

ok(!defined $t5->{$tm3->name}, "sremove_by_id" . Dumper($t5));

$tt = $tm3->create({
    test_name  => "a",
    test_intro => "b",
    test_id    => 2
  }
)->{$tm3->name};

$tm3->sremove($tt->{test_id}, $tt->{test_name}, 6);

my $t6 = $tm3->get_by_id($tt->{test_id}, $tt->{test_name});

ok(!defined $t6->{$tm3->name}, "sremove by id " . Dumper($t6));

$tt = $tm3->create({
    test_name  => "a",
    test_intro => "b",
    test_id    => 3
  }
)->{$tm3->name};

$tm3->sremove($tt, 7);

my $t7 = $tm3->get_by_test_name($tt->{test_name});

ok(!defined $t7->{$tm3->name}, "sremove by obj " . Dumper($t7));

done_testing;


