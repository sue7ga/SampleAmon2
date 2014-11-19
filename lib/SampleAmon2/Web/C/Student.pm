package SampleAmon2::Web::C::Student;

use strict;
use warnings;

use utf8;
use SampleAmon2::Model::Pref;

my $pref = new SampleAmon2::Model::Pref();
my @prefs = $pref->show();

sub register{
  my($class,$c) = @_;
  return $c->render('register.tx',{prefs => \@prefs});
}

sub list{
 my ($class,$c) = @_;
 my $students = $c->db->get_students; 
 return $c->render('student_list.tx',{students => $students});
}

sub mypage{
 my($class,$c) = @_;
 if(!$c->session->get('student')){
   return $c->redirect('/student/login');
 }
 return $c->render('mypage.tx');
}

1;
