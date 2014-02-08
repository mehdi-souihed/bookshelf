package Web;
use Dancer ':syntax';
use Controller;
use Book;
use GoogleApi;
use Data::Dumper;

use v5.10;

our $VERSION = '0.1';

get '/bookshelf' => sub {
    template 'bookshelf_index';
};

get '/add_book' => sub {
    template 'add_book';
};

post '/add_book' => sub {

my $book = Book->new(
        title   => params->{title},
        author  => params->{author},
        pages   => params->{pages},
        isbn    => params->{isbn},
        year    => params->{year},
        genre   => params->{genre},
        url     => params->{url},
        link_image => params->{link_image},
        status  => params->{status},
        tags    => params->{tags}, 
);

 Controller::add_book($book);
 
 redirect '/bookshelf';

};

get '/add_user' => sub {
    template 'add_user';
};

post '/add_user' => sub {

my $user = User->new(
        fname   => params->{fname},
        lname  => params->{lname},
        email   => params->{email},
        user_password    => params->{upass},
);

 Controller::add_user($user);
 
 redirect '/bookshelf';

};

get '/login' => sub {
    template 'login';
};

post '/login' => sub {

 Controller::login(params->{email}, params->{upass})? redirect '/bookshelf' : template 'login',{login_failed => 1};

};

get '/search_book' => sub {
    template 'search_book';
};

post '/results_books' => sub {
    my $results = GoogleApi::search_book(params->{keyword});
    
    template 'results_books',{results => $results, search => params->{keyword}} ;
};


true;
