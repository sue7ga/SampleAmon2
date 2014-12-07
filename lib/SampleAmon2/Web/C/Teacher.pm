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
 #my $teachers =  $c->db->search_teacher($c->req->parameters);
 #my $teachers = $c->db->search_all_teachers();
 return $c->render('teachers_search.tx');
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

sub detail{
 my($class,$c,$args) = @_;
 my $teacher = $c->db->search_teacher_by_id($args->{id});
 my $email = $teacher->email;
 my $name = $teacher->name;
 my $gender = $teacher->gender;
 my $school = $teacher->school;
 my $prefecture = $teacher->prefecture;
 my $profile = $teacher->profile;
 return $c->render('teacher_detail.tx',{name => $name,email => $email,gender => $gender,school=> $school,prefecture => $prefecture,profile => $profile});
}

sub mypage{
 my($class,$c) = @_;
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

sub message{
 my($class,$c) = @_;
 my $itr = $c->db->get_message_by_teacherid($c->session->get('teacher'));
 my $messages = [];
 while(my $row = $itr->next){
  my $student = $c->db->search_student_by_id($row->studentid);
  push $messages,{title => "生徒名：".$student->name."タイトル：".$row->title,content => $row->message};
 }
 return $c->render('teacher_message.tx',{messages => $messages});
}

sub jsonshow{
 my($class,$c) = @_;
my $itr = $c->db->search_all_teachers_by_itr();
  my $teachers = [];
  while(my $row = $itr->next){
      push @$teachers,{id => $row->id,name => $row->name,gender => $row->gender,school => $row->school,prefecture => $row->prefecture}
  }
  return $c->render_json($teachers);
}

sub messagedelete{
 my($class,$c) = @_;
 return $c->redirect('/teacher/message/box');
}

sub json_student_show{
 my($class,$c) = @_;
 my $itr = $c->db->search_all_students(); 
  my $students = [];
  while(my $row = $itr->next){
      push @$students,{id => $row->id,name => $row->name,gender => $row->gender,school => $row->school,prefecture => $row->prefecture}
  }
  return $c->render_json($students);
}

#json

use SampleAmon2::Model::Person;
my $person = new SampleAmon2::Model::Person();

sub jsonmodalteacher{
  my($class,$c) = @_;
  my $teacherid = $c->req->param('teacherid');
  my $teacher = $c->db->search_by_teacherid($teacherid);
  my $info = $person->modal_info($teacher);
  my $teacher_structure = {'teacherinfo' => $info};
 return $c->render_json($teacher_structure);
}

sub jsonmodal{
 my($class,$c) =  @_;
 my $studentid =  $c->req->param('studentid'); 
 my $student = $c->db->search_by_studentid($studentid);
 my $info = $person->modal_info($student);
 my $student_structure = {'studentinfo' => $info};
 return $c->render_json($student_structure);
}

sub inbox{
 my($class,$c) = @_;
 my $itr = $c->db->get_message_inbox_by_teacherid($c->session->get('teacher')); 
 my $messages = [];
 while(my $row = $itr->next){
   my $student = $c->db->search_student_by_id($row->studentid); 
   push $messages,{title => "生徒名：".$student->name."タイトル：".$row->title,content => $row->message};
 } 
 return $c->render('teacher_inbox.tx',{messages => $messages});
}

sub postmessage{
 my($class,$c,$args) = @_;
 my $param = $c->req->parameters;
 my $teacher_id = $c->session->get('teacher');
 $c->db->send_message_to_student_by_teacher($teacher_id,$param);
 return $c->redirect('/teacher/mypage');
}

sub setting{
 my($class,$c) = @_;
 my $teacher = $c->db->get_now_teacher($c->session->get('id'));
 my $email = $teacher->email;
 my $age = $teacher->age;
 my $prefecture = $teacher->prefecture;
 my $income = $teacher->income;
 my $day = $teacher->day;
 my $profile = $teacher->profile;
 my $teaching = $teacher->teaching;
 return $c->render('teacher_setting.tx',{prefs => \@prefs,email => $email,age => $age,pref => $prefecture,income => $income,day => $day,profile => $profile,teaching => $teaching});
}

sub update{
 my($class,$c,$args) = @_;
 my $param = $c->req->parameters;
 $param->remove('email_check');
 $param->remove('XSRF-TOKEN');
 $c->db->update_teacher($param,$c->session->get('teacher'));
 return $c->redirect('/teacher/mypage');
}

sub show{
 my($class,$c,$args) = @_;
 my $student =  $c->db->search_student_by_id($args->{id});
 my $name = $student->name;
 my $gender = $student->gender;
 my $age = $student->age;
 my $school = $student->school;
 my $prefecture = $student->prefecture;
 my $profile = $student->profile;
 my $day = $student->day;
 return $c->render('teacher_show.tx',{id => $args->{id},name => $name,gender => $gender,age => $age,school => $school,prefecture => $prefecture,profile => $profile,day => $day});
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
    $c->session->set('id' => $teacher->id);
    return $c->redirect('/teacher/mypage');
  }
}

1;
