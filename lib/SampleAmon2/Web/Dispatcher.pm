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

#student

get 'student/register' => "Student#register";

post 'student/register' => "Student#postregister";

get 'student/list' => "Student#list";

post 'student/login' => "Studet#postlogin";

get 'student/mypage' => "Student#mypage";

get '/mypage' => "Student#mypage";

#teacher

get 'teacher/register' => "Teacher#register";

get 'teachers/search' => "Teacher#search";

post 'teachers/search' => "Teacher#postsearch";

post 'teacher/register' => "Teacher#postregister"; 

get 'teacher/login' => "Teacher#login";

get 'teacher/mypage' => "Teacher#mypage";

get 'teacher/logout' => "Teacher#logout";

post 'teacher/login' => "Teacher#postlogin";

get 'teacher/list' => "Teacher#list";

get 'teacher/login' => "Teacher#login";

#js

use SampleAmon2::Model::Person;
my $person = new SampleAmon2::Model::Person();

get '/js/modal' => sub{bbbbbbb
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

1;




