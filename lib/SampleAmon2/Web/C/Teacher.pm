package SampleAmon2::Web::C::Teacher;

use strict;
use warnings;
use Data::Dumper;
use utf8;

use SampleAmon2::Model::Pref;

my $pref = new SampleAmon2::Model::Pref();
my @prefs = $pref->show();

sub login_required{
 my($self,$session) = @_;
  $session->set('teacher' => 1);
}

sub required_login{
 my($self,$session) = @_;
 unless($session->get('teacher')){
   return 1;
 }
}

sub register{
 my($class,$c) = @_;
 return $c->render('teacher_register.tx',{prefs => \@prefs});
};

sub postregister{
 my ($class,$c) = @_;
 $c->db->insert_teacher($c->req->parameters);
 return $c->render('teacher_login.tx');
};

sub search{
 my($class,$c) = @_;
 return $c->render('teachers_search.tx',{prefs => \@prefs});
};

sub postsearch{
 my ($class,$c) = @_;
 my $teachers =  $c->db->search_teacher($c->req->parameters);
 return $c->render('teachers_search.tx',{teachers => $teachers});
}

sub list{
 my ($class,$c) = @_;
 my $teachers = $c->db->get_teachers; 
 return $c->render('teacher_list.tx',{teachers => $teachers});
}

sub login{
 my($class,$c) = @_;
 return $c->render('teacher_login.tx');
}

sub mypage{
 my($class,$c) = @_;
 print Dumper $c->session->get('teacher');
 if($c->session->get('teacher')){
   return $c->render('teacher_mypage.tx');
 }else{
  return $c->render('teacher_login.tx');
 }
};

sub logout{
 my ($class,$c) = @_;
 $c->session->set('teacher' => 0);
 return $c->redirect('/teacher/login');
};

sub showstudent{
 my($class,$c) = @_; 
 return $c->render('teacher_student_list.tx');
}

sub postlogin{
  my($class,$c) = @_;
  my $email = $c->req->{'amon2.body_parameters'}->{email};
  my $password = $c->req->{'amon2.body_parameters'}->{password};
  my $teacher = $c->db->get_teacher_mail_and_pass($email);
  unless($teacher){
    return $c->redirect('/teacher/login');
  }
  if($password eq $teacher->password){
    $class->login_required($c->session);
    return $c->redirect('/teacher/mypage');
  }
}

1;
