package SampleAmon2::Model::Person;

use strict;
use warnings;
use Mouse;
use utf8;

sub login{
 my($self,$session,$user) = @_;
 $session->set($user => 1);
}

sub logout{
 my($self,$session,$user) = @_;
 $session->set($user => 0);
}

sub required_login{
 my($self,$session) = @_;
 unless($session->get('user')){
   return 1;
 }
}

sub modal_info{
 my($self,$person) = @_;
 my $info = '';
 while(my $row = $person->next){
    $info .= "<h3>".$row->get_columns->{name}."の詳細"."</h3>"."</br>";
    $info .= "メールアドレス：".$row->get_columns->{email}."</br>";
    $info .= "高校名：".$row->get_columns->{school}."</br>";
    $info .= "自己紹介：".$row->get_columns->{profile}."</br>";
 }
 return $info;
}


1;
