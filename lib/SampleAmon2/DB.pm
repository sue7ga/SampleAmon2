package SampleAmon2::DB;
use strict;
use warnings;
use utf8;
use parent qw(Teng);
use DateTime;
use Data::Dumper;

use DBI;

__PACKAGE__->load_plugin('Count');
__PACKAGE__->load_plugin('Replace');
__PACKAGE__->load_plugin('Pager');

sub insert_student{
 my($self,$args) = @_;
 $self->insert('students',{email => $args->{email},password=>$args->{password},name => $args->{name},school => $args->{school},age => $args->{age},prefecture => $args->{prefecture},day => $args->{day},profile => $args->{profile},gender => $args->{gender}});
}

sub insert_teacher{
  my($self,$args) = @_;
 
 $self->insert('teachers',{email => $args->{email},password=>$args->{password},name => $args->{name},school => $args->{school},age => $args->{age},prefecture=> $args->{prefecture},income => $args->{income},day => $args->{day},teaching => $args->{teaching},profile => $args->{profile},gender => $args->{gender}});
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

sub search_student_by_id{
 my($self,$id) = @_;
 my $itr = $self->single(
   "students",{id => $id}
 );
 return $itr;
}

sub get_now_teacher{
 my($self,$id) = @_;
 my $itr = $self->single(
   "teachers",{id => $id}
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

sub update_teacher{
 my($self,$params) = @_;
 $self->update();

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

use Encode;

sub search_teacher{
 my($self,$args) = @_;
 my $school = $args->get('school');
 my $prefecture = $args->get('pref_name');
 my $age = $args->get('age');

 my @rows = $self->search_named('SELECT * FROM teachers WHERE school = :school OR prefecture = :prefecture OR age = :age ',+{school => $school,prefecture => $prefecture,age => $age});

 return \@rows;
}

sub search_all_students{
 my ($self) = shift;
 my $itr = $self->search('students');
 return $itr;
}

1;
