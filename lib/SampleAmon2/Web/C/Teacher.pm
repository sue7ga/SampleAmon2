package SampleAmon2::Web::C::Teacher;

use strict;
use warnings;
use Data::Dumper;
use utf8;

use SampleAmon2::Model::Pref;

my $pref = new SampleAmon2::Model::Pref();
my @prefs = $pref->show();

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
 my $user = $c->session->get('teacheruser') || 0;
  return $c->render('teacher_login.tx');
}

sub mypage{
 my($class,$c) = @_;
 return $c->render('teacher_mypage.tx');
};

sub logout{
 my ($class,$c) = @_;
 $c->session->set('teacher' => 0);
 return $c->redirect('/login');
};

sub postlogin{
  my($class,$c) = @_;
  my $email = $c->req->{'amon2.body_parameters'}->{email};
  my $password = $c->req->{'amon2.body_parameters'}->{password};
  my $teacher = $c->db->get_teacher_mail_and_pass($email);
  unless($teacher){
    return $c->redirect('/teacher/login');
  }
  if($password eq $teacher->password){
    $c->session->set('teacheruser' => 1);
    return $c->redirect('/teacher/mypage');
  }
}

1;
