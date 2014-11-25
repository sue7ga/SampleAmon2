package SampleAmon2::Web::C::Student;
use strict;
use warnings;

use utf8;
use SampleAmon2::Model::Pref;

my $pref = new SampleAmon2::Model::Pref();
my @prefs = $pref->show();

sub required_login{
 my($self,$session) = @_;
 unless($session->get('student')){
   return 1;
 }
}

sub register{
  my($class,$c) = @_;
  return $c->render('register.tx',{prefs => \@prefs});
}

sub postregister{
 my ($class,$c) = @_;
 $c->db->insert_student($c->req->parameters);
 return $c->render('login.tx')
}

sub login{
 my($class,$c) = @_;
 return $c->render('login.tx');
}

use Data::Dumper;

sub postlogin{
  my ($class,$c) = @_;
  my $email = $c->req->{'amon2.body_parameters'}->{email};
  my $password = $c->req->{'amon2.body_parameters'}->{password};
  my $student = $c->db->get_student_mail_and_pass($email);
  if($password eq $student->password){
    $c->session->set('student' => 1);
    $c->session->set('studentid' => $student->id);
    print Dumper $c->session->get('student');
    return $c->redirect('/student/mypage');
  }
  return $c->redirect('/student/login');
}

sub list{
 my ($class,$c) = @_;
 if($c->session->get('teacher')){
  my $students = $c->db->get_students;
  return $c->render('student_list.tx',{students => $students});
 }else{
  return $c->render('teacher_login.tx');
 }
}

sub mypage{
 my($class,$c) = @_;
 if(!$c->session->get('student')){
   return $c->redirect('/student/login');
 }
 return $c->render('mypage.tx');
}

sub teacherslist{
 my($class,$c) = @_;
 return $c->render('student_teachers_list.tx');
}

sub teachers_show{
 my($class,$c) = @_;
 my $itr = $c->db->search_all_teachers();
 my $teachers = [];
  while(my $row = $itr->next){
      push @$teachers,{id => $row->id,name => $row->name,gender => $row->gender,school => $row->school,prefecture => $row->prefecture}
  }
  return $c->render_json($teachers);
}

sub teacher_show{
 my($class,$c,$args) = @_;
 my $teacher = $c->db->get_now_teacher($args->{id});
 my $name = $teacher->name;
 my $id = $teacher->id;
 my $school = $teacher->school;
 my $prefecture = $teacher->prefecture;
 my $profile = $teacher->profile;
 my $day = $teacher->day;
 return $c->render('student_teacher_detail.tx',{name => $name,school => $school,prefecture =>$prefecture,profile=>$profile,day=>$day});
}

sub postmessage{
 my($class,$c) = @_;
 my $param = $c->req->parameters;
 print Dumper $param;
 #my $student = $c->db->search_student_by_id($c->session->get('studentid'));
 #$c->db->send_message_to_teacher_by_student($student->id,$param);
 return $c->redirect('/student/teachers/list');
}

sub logout{
 my($class,$c) = @_;
 $c->session->set('student'=> 0);
 print Dumper $c->session->get('student');
 print Dumper $c->session->get('studentid');
 return $c->redirect('/student/login');
}

sub setting{
 my($class,$c) = @_;
 my $teacher = $c->db->search_student_by_id($c->session->get('studentid'));
 my $email = $teacher->email;
 my $age = $teacher->age;
 my $prefecture = $teacher->prefecture;
 my $day = $teacher->day;
 my $profile = $teacher->profile;
 return $c->render('student_setting.tx',{prefs => \@prefs,email => $email,age => $age,prefecture => $prefecture,day => $day,profile=>$profile});
}

sub setting_update{
 my($class,$c) = @_;
 my $param = $c->req->parameters;
 $param->remove('XSRF-TOKEN');
 $param->remove('email_check');
 $c->db->student_update($param,$c->session->get('studentid'));
 return $c->redirect('/student/setting');
}

sub password{
 my($class,$c) = @_;
 return $c->render('student_password.tx');
}

sub postpass{
 my($class,$c) = @_;
 my $param =  $c->req->parameters;
 $param->remove('XSRF-TOKEN');
 if($param->{password} eq $param->{pass_confirm}){
  $param->remove('pass_confirm');
  print Dumper $param;
  $c->db->register_pass($param,$c->session->get('studentid'));
 }else{
    return $c->redirect('/settings/password');
 }
 return $c->redirect('/settings/password');
}

sub settingbox{
 my($class,$c) = @_;
 return $c->render('student_box.tx');
}

1;
