package T::MyDBIxCustom;
use Mojolicious::DBIxCustom -base;
use strict;
use warnings;

sub last_id{
  shift->select("last_insert_rowid()")->value;
}

1;