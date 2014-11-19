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

sub search{
 my($class,$c) = @_;
 return $c->render('teachers_search.tx',{prefs => \@prefs});
};

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

1;
