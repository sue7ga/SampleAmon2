package SampleAmon2::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::RouterBoom;

use Module::Find;

useall 'SampleAmon2::Web::C';
base 'SampleAmon2::Web::C';

use Data::Dumper;

any '/' => sub {
    my ($c) = @_;
    my $counter = $c->session->get('counter') || 0;
    $counter++;
    $c->session->set('counter' => $counter);
    return $c->render('index.tx', {
        counter => $counter,
    });
};

use SampleAmon2::Model::Pref;

my $pref = new SampleAmon2::Model::Pref();
my @prefs = $pref->show();

get 'student/register' => "Student#register";

get 'teacher/register' => "Teacher#register";

get 'teachers/search' => "Teacher#search";

post 'teachers/search' => sub{
 my ($c) = @_;
 my $teachers =  $c->db->search_teacher($c->req);
 return $c->render('teachers_search.tx',{teachers => $teachers});
};

post 'student/register' => sub{
 my ($c) = @_;
 $c->db->insert_student($c->req->parameters);
 return $c->render('login.tx')
};

post 'teacher/register' => sub{
 my ($c) = @_;
 $c->db->insert_teacher($c->req->parameters);
 return $c->render('teacher_login.tx');
};

get 'student/list' => "Student#list";

get 'teacher/list' => "Teacher#list";

get 'login' => "Teacher#login";

use SampleAmon2::Model::Person;
my $person = new SampleAmon2::Model::Person();

get '/js/modal' => sub{
 my($c,$args) = @_;
 my $studentid =  $c->req->param('studentid'); 
 my $student = $c->db->search_by_studentid($studentid);
 my $info = $person->modal_info($student);
 my $student_structure = {'studentinfo' => $info};
 return $c->render_json($student_structure);
};

get '/js/modal/teacher' => sub{
  my($c,$args) = @_;
  my $teacherid = $c->req->param('teacherid');
  my $teacher = $c->db->search_by_teacherid($teacherid);
  my $info = $person->modal_info($teacher);
  my $teacher_structure = {'teacherinfo' => $info};
 return $c->render_json($teacher_structure);
};

get 'teacher/login' => "Teacher#login";

get 'teacher/mypage' => "Teacher#mypage";

get 'student/mypage' => "Student#mypage";

get 'logout' => "Teacher#logout";

post 'student/login' => sub{
  my ($c) = shift;
  my $email = $c->req->{'amon2.body_parameters'}->{email};
  my $password = $c->req->{'amon2.body_parameters'}->{password};  
  my $student = $c->db->get_student_mail_and_pass($email);
  if($password eq $student->password){
    $c->session->set('user' => 1);
    return $c->redirect('/student/mypage');
  }
  return $c->redirect('/student/login');
};

post 'teacher/login' =>sub{
  my($c) = shift;
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
};

get '/mypage' => "Student#mypage";


1;




