package SampleAmon2::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::RouterBoom;
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

get 'student/register' => sub{
 my ($c) = @_;  
 return $c->render('register.tx');
};

get 'teacher/register' => sub{
 my($c) = @_;
 return $c->render('teacher_register.tx');
};

post 'student/register' => sub{
 my ($c) = @_; 
 $c->db->insert_student($c->req);
 return $c->render('login.tx')
};

post 'teacher/register' => sub{
 my ($c) = @_;
 $c->db->insert_teacher($c->req);
 return $c->render('teacher_login.tx');
};

get 'student/list' => sub{
 my ($c) = @_;
 my $students = $c->db->get_students; 
 return $c->render('student_list.tx',{students => $students});
};

get 'teacher/list' => sub{
 my ($c) = @_;
 my $teachers = $c->db->get_teachers; 
 return $c->render('teacher_list.tx',{teachers => $teachers});
};

get '/login' => sub{
  my($c) = @_;
  my $user = $c->session->get('user') || 0;
  return $c->render('login.tx');
};

get '/js/modal' => sub{
 my($c,$args) = @_;
 my $studentid =  $c->req->param('studentid'); 
 my $student = $c->db->search_by_studentid($studentid);
 my $student_info = '';
 while(my $row = $student->next){
    $student_info .= "<h3>".$row->get_columns->{name}."の詳細"."</h3>"."</br>";
    $student_info .= "メールアドレス：".$row->get_columns->{email}."</br>";
    $student_info .= "高校名：".$row->get_columns->{school}."</br>";
    $student_info .= "自己紹介：".$row->get_columns->{profile}."</br>";
 }
 my $student_structure = {'studentinfo' => $student_info};
 return $c->render_json($student_structure);
};

get 'teacher/login' => sub{
  my($c) = @_;
  my $user = $c->session->get('user') || 0;
  return $c->render('teacher_login.tx');
};


get '/mypage' => sub{
 my($c) = @_;
 if(!$c->session->get('user')){
   return $c->redirect('/login');
 }
 return $c->render('mypage.tx');
};

get '/logout' => sub{
 my ($c) = @_;
 $c->session->set('user' => 0);
 return $c->redirect('/login');
};

post 'student/login' => sub{
  my ($c) = shift;
  my $email = $c->req->{'amon2.body_parameters'}->{email};
  my $password = $c->req->{'amon2.body_parameters'}->{password};
  if($email eq 'test' && $password eq 'test'){
    $c->session->set('user' => 1);
    return $c->redirect('/mypage');
  }
  return $c->redirect('/login');
};

post 'teachr/login' =>sub{
 my($c) = shift;
  my $email = $c->req->{'amon2.body_parameters'}->{email};
  my $password = $c->req->{'amon2.body_parameters'}->{password};
  if($email eq 'test' && $password eq 'test'){
    $c->session->set('user' => 1);
    return $c->redirect('teacher/mypage');
  }
  return $c->redirect('teacher/login');
};

1;




