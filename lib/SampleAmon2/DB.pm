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

 my $email = $param->{'amon2.body_parameters'}->{email};
 my $password = $param->{'amon2.body_parameters'}->{password};
 my $name = $param->{'amon2.body_parameters'}->{name};
 my $school = $param->{'amon2.body_parameters'}->{school};
 my $age = $param->{'amon2.body_parameters'}->{age};
 my $prefecture = $param->{'amon2.body_parameters'}->{prefecture};
 my $income = $param->{'amon2.body_parameters'}->{income};
 my $day = $param->{'amon2.body_parameters'}->{day};
 my $teaching = $param->{'amon2.body_parameters'}->{teaching};
 my $profile = $param->{'amon2.body_parameters'}->{profile};

 my $dt = DateTime->now();
 $self->insert('teachers',{mail => $email,password=>$password,name => $name,school => $school,age => $age,prefecture=> $prefecture,income => $income,day => $day,teaching => $teaching,profile => $profile,created_at => $dt,updated_at => $dt});

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

sub search_by_studentid{
 my ($self,$studentid) = @_;
 my $itr = $self->search(
   students => {id => [$studentid]}
 );
 return $itr;

}

1;
