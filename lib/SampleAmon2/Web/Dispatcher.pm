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
 my @prefs = ("北海道","青森県","宮城県","秋田県","山形県","福島県","茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県","新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県","静岡県","愛知県","三重県","滋賀県","京都府","大阪府","兵庫県","奈良県","和歌山県","鳥取県","島根県","岡山県","広島県","山口県","徳島県","香川県","愛媛県","高知県","福岡県","佐賀県","長崎県","熊本県","大分県","宮崎県","鹿児島県","沖縄県");
 return $c->render('register.tx',{prefs => \@prefs});
};

get 'teacher/register' => sub{
 my($c) = @_;
 my @prefs = ("北海道","青森県","宮城県","秋田県","山形県","福島県","茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県","新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県","静岡県","愛知県","三重県","滋賀県","京都府","大阪府","兵庫県","奈良県","和歌山県","鳥取県","島根県","岡山県","広島県","山口県","徳島県","香川県","愛媛県","高知県","福岡県","佐賀県","長崎県","熊本県","大分県","宮崎県","鹿児島県","沖縄県");
 return $c->render('teacher_register.tx',{prefs => \@prefs});
};

post 'student/register' => sub{
 my ($c) = @_; 
 $c->db->insert_student($c->req);
 return $c->render('login.tx')
};

post 'teacher/register' => sub{
 my ($c) = @_;
 print Dumper $c->req;
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

get '/js/modal/teacher' => sub{
 my($c,$args) = @_;
  my $teacherid = $c->req->param('teacherid');
  my $teacher = $c->db->search_by_teacherid($teacherid);
  my $teacher_info = '';
  while(my $row = $teacher->next){
    $teacher_info .= "<h3>".$row->get_columns->{name}."の詳細"."</h3>"."</br>";
    $teacher_info .= "メールアドレス：".$row->get_columns->{email}."</br>";
    $teacher_info .= "大学名：".$row->get_columns->{school}."</br>";
    $teacher_info .= "自己紹介：".$row->get_columns->{profile}."</br>";
  }
  my $teacher_structure = {'teacherinfo' => $teacher_info};
 return $c->render_json($teacher_structure);


};

get 'teacher/login' => sub{
  my($c) = @_;
  my $user = $c->session->get('teacheruser') || 0;
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
  my $student = $c->db->get_student_mail_and_pass($email);
  if($password eq $student->password){
    $c->session->set('user' => 1);
    return $c->redirect('/mypage');
  }
  return $c->redirect('/login');
};

post 'teacher/login' =>sub{
  my($c) = shift;
  my $email = $c->req->{'amon2.body_parameters'}->{email};
  my $password = $c->req->{'amon2.body_parameters'}->{password};
  my $teacher = $c->db->get_teacher_mail_and_pass($email);
  if($password eq $teacher->password){
    print Dumper "hoge";
    $c->session->set('teacheruser' => 1);
    return $c->redirect('teacher/login');
  }
  return $c->redirect('teacher/login');
};


1;




