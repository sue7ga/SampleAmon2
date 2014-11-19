package SampleAmon2::DB;
use strict;
use warnings;
use utf8;
use parent qw(Teng);
use DateTime;
use Data::Dumper;

__PACKAGE__->load_plugin('Count');
__PACKAGE__->load_plugin('Replace');
__PACKAGE__->load_plugin('Pager');

sub insert_student{
 my($self,$param) = @_;
 
  my $email = $param->{'amon2.body_parameters'}->{email};
  my $password = $param->{'amon2.body_parameters'}->{password};
  my $name = $param->{'amon2.body_parameters'}->{name};
  my $school = $param->{'amon2.body_parameters'}->{school};
  my $age = $param->{'amon2.body_parameters'}->{age};
  my $prefecture = $param->{'amon2.body_parameters'}->{prefecture};
  my $day = $param->{'amon2.body_parameters'}->{day};
  my $profile = $param->{'amon2.body_parameters'}->{profile}; 
  my $gender = $param->{'amon2.body_parameters'}->{gender};

 $self->insert('students',{email => $email,password=>$password,name => $name,school => $school,age => $age,prefecture => $prefecture,day => $day,profile => $profile,gender => $gender});

}

sub insert_teacher{
my($self,$param) = @_;
 
  my @columns = ('email','password','name','school','age','prefecture','income','day','teaching','profile','gender');
 
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
  my $gender = $param->{'amon2.body_parameters'}->{gender};

 $self->insert('teachers',{email => $email,password=>$password,name => $name,school => $school,age => $age,prefecture=> $prefecture,income => $income,day => $day,teaching => $teaching,profile => $profile});

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

sub get_teachers{
 my($self) = @_;
  
 my @rows = $self->search(
   'teachers',
                          {},
                          {order_by => {'id' => 'DESC'},limit=> 20}
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

sub search_by_teacherid{
 my ($self,$teacherid) = @_;
 my $itr = $self->search(
   teachers => {id => [$teacherid]}
 );
 return $itr;

}

sub get_student_mail_and_pass{
 my ($self,$email) = @_;
 my $itr = $self->single(
   "students",{email => $email}
 );
 return $itr;
}

sub get_teacher_mail_and_pass{
 my ($self,$email) = @_;
 my $itr = $self->single(
   "teachers",{email => $email}
 );
 return $itr;
}

sub search_teacher{
 my($self,$args) = @_;

 print Dumper $args;
 
 return $args;
}

1;
