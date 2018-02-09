package T::Model::tmodel2;
use T::Model -base;
use strict;
use warnings;

has columns => sub{
    [
      "test_id", "test_name", "test_intro", "create_time", "update_time",
      "is_deleted"
    ]
  };


has ctime => "create_time";
has mtime => "update_time";
has primary_key => sub{["test_id"]};
has sdel => "is_deleted";


1;