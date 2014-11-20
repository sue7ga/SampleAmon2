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

sub postregister{
 my ($class,$c) = @_;
 $c->db->insert_student($c->req->parameters);
 return $c->render('login.tx')
}

sub postlogin{
  my ($class,$c) = shift;
  my $email = $c->req->{'amon2.body_parameters'}->{email};
  my $password = $c->req->{'amon2.body_parameters'}->{password};  
  my $student = $c->db->get_student_mail_and_pass($email);
  if($password eq $student->password){
    $c->session->set('user' => 1);
    return $c->redirect('/student/mypage');
  }
  return $c->redirect('/student/login');
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
