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

get 'student/login' => "Student#login";

get 'student/logout' => "Student#logout";

post 'student/login' => "Student#postlogin";

get 'student/mypage' => "Student#mypage";

get '/mypage' => "Student#mypage";

get 'student/teachers/list' => "Student#teacherslist";

get 'student/teacher/show/:id' => "Student#teacher_show";

post 'toteacher/message' => "Student#postmessage";

get 'student/setting' => "Student#setting";

get 'student/message/box' => "Student#settingbox";

get 'settings/password' => "Student#password";

post 'student/postpass' => "Student#postpass";

post 'student/setting/update' => "Student#setting_update";

post 'student/message' => "Student#sendmessage";

#json
get 'student/teachers/show' => "Student#teachers_show";


#teacher
get 'message/delete' => "Teacher#messagedelete";
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

get 'teacher/student/list' => "Teacher#showstudent";

get 'teacher/setting' => "Teacher#setting";

get 'teacher/show/:id' => "Teacher#show";

get 'teachers/detail/:id' =>"Teacher#detail";

post 'teacher/message' => "Teacher#postmessage";

get 'teacher/message/sendbox' => "Teacher#message";

get 'teacher/message/box' => "Teacher#inbox";

get 'teacher/settings' => "Teacher#setting";

post 'teacher/setting/update' => "Teacher#update";

#json
get 'teachers/show' => "Teacher#jsonshow";

#js

get '/js/modal' => "Teacher#jsonmodal";

get '/teacher/student/students/show' => "Teacher#json_student_show";

get '/js/modal/teacher' => "Teacher#jsonmodalteacher";

1;




