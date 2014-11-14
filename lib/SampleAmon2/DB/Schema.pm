package SampleAmon2::DB::Schema;
use strict;
use warnings;
use utf8;
use DateTime;

use Teng::Schema::Declare;

base_row_class 'SampleAmon2::DB::Row';

table {
    name 'students';
    pk 'id';
    columns qw(id email password name school profile);
};

table{
   name 'teachers';
   pk 'id';
   columns qw(id email password name school age prefecture income day teaching profile created_at updated_at);
  inflate qr/.+_at/ => sub{
    my($col_value) = @_;
    DateTime->from_epoch($col_value);
  };
  deflate qr/.+_at/ => sub{
     my($col_value) = @_;
    $col_value->epoch;
  }
};

1;
