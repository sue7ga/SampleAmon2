package SampleAmon2::DB;
use strict;
use warnings;
use utf8;
use parent qw(Teng);
use DateTime;

__PACKAGE__->load_plugin('Count');
__PACKAGE__->load_plugin('Replace');
__PACKAGE__->load_plugin('Pager');

sub insert_student{
 my($self,$param) = @_;
 
 my $email = $param->{'amon2.body_parameters'}->{email};
 my $password = $param->{'amon2.body_parameters'}->{password};
 my $name = $param->{'amon2.body_parameters'}->{name};
 my $school = $param->{'amon2.body_parameters'}->{school};
 my $profile = $param->{'amon2.body_parameters'}->{profile};

 $self->insert('students',{email => $email,password=>$password,name => $name,school => $school,profile => $profile});

}

sub insert_teacher{
my($self,$param) = @_;
 
 my @columns = ('email','password','name','school','age','prefecture','income','day','teaching','profile');

 map{my $.$_ = $param->{'amon2.body_parameters'}->{$_}}@columns;

 my $dt = DateTime->new();
 $self->insert('teachers',{email => $email,password=>$password,name => $name,school => $school,age => $age,prefecture=> $prefecture,income => $income,day => $day,teaching => $teaching,profile => $profile,created_at => $dt,updated_at => $dt});

}

sub get_students{
 my ($self) = @_;

 my @rows = $self->search(
    'students',
     {},
     {order_by => {'id' => 'DESC'},limit => 20}
 );

 return \@rows;
}

1;
