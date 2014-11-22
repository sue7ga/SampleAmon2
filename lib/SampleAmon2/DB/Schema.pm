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
    columns qw(id email password name school gender age prefecture day profile created_at updated_at);
  inflate qr/.+_at/ => sub{
    my($col_value) = @_;
    DateTime->from_epoch($col_value);
  };
  deflate qr/.+_at/ => sub{
     my($col_value) = @_;
    $col_value->epoch;
  }
};

table{
   name 'teachers';
   pk 'id';
   columns qw(id email password name school gender age prefecture income day teaching profile created_at updated_at);
  inflate qr/.+_at/ => sub{
    my($col_value) = @_;
    DateTime->from_epoch($col_value);
  };
  deflate qr/.+_at/ => sub{
     my($col_value) = @_;
    $col_value->epoch;
  }
};

table{
  name 'messages';
  pk 'id';
  columns qw(id title message studentid teacherid from_to created_at);
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
