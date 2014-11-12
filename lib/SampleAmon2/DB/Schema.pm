package SampleAmon2::DB::Schema;
use strict;
use warnings;
use utf8;

use Teng::Schema::Declare;

base_row_class 'SampleAmon2::DB::Row';

table {
    name 'students';
    pk 'id';
    columns qw(id email password name school profile);
};

1;
