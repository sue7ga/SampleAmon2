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

get '/register' => sub{
 my ($c) = @_;  
 return $c->render('register.tx');
};

post '/register' => sub{
 my ($c) = @_;
 return $c->render('mypage.tx')
};

get '/login' => sub{
  my($c) = @_;
  my $user = $c->session->get('user') || 0;
  return $c->render('login.tx');
};

get '/mypage' => sub{
 my($c) = @_;
 print Dumper $c->session->get('user');
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

post 'teacher/login' => sub{
  my ($c) = shift;
  my $email = $c->req->{'amon2.body_parameters'}->{email};
  my $password = $c->req->{'amon2.body_parameters'}->{password};
  if($email eq 'test' && $password eq 'test'){
    $c->session->set('user' => 1);
    return $c->redirect('/mypage');
  }
  return $c->redirect('/login');
};


1;
