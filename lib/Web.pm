package Web;
use Dancer ':syntax';
use Dancer::Plugin::Ajax;
use Controller;
use Book;
use GoogleApi;
use Data::Dumper;

use v5.10;

our $VERSION = '0.1';

get '/' => sub {

	redirect '/bookshelf';
};

get '/bookshelf' => sub {
	
	template 'bookshelf_index';
};

get '/add_book' => sub {
	if(session('user')){

	   template 'add_book';
	}
	else {
	redirect '/bookshelf';
	}
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
#	Controller::add_book($book);

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

get '/logout' => sub {
	session->destroy;
	redirect '/bookshelf';

};

post '/login' => sub {
#	Validate the username and password 
	if(Controller::login(params->{email}, params->{upass})){ 
		session user => params->{email};
		redirect '/bookshelf'; 	
	}
       	
	template 'login',{login_failed => 1};
};

get '/search_book' => sub {
	template 'search_book';
};

post '/results_books' => sub {
	my $results = GoogleApi::search_book(params->{keyword}, session('user'));

	template 'results_books',{results => $results, search => params->{keyword}} ;
};

get '/my_books' => sub{
	my $results = Controller::get_full_info_list_user(session('user'));

	template 'my_books', {results => $results, nb_results => scalar @{$results}};
};

ajax '/user/:action' => sub {

	my $response = undef;
	if (params->{action} eq 'add_book'){
	my $book = Book->new(
		googleid   => params->{id},
		nb_pages   => params->{nb_pages},
		title   => params->{title},
		author  => params->{authors},
	        description => params->{desc},
		image_link => params->{image_link},
		categories   => params->{categories},
	);
		$response = Controller::add_book_user(session('user'),$book);
	}

	if (params->{action} eq 'make_book_visible'){
		$response =  Controller::delete_book_user(session('user'),params->{id});
	}

	if (params->{action} eq 'make_book_invisible'){
		$response =  Controller::delete_book_user(session('user'),params->{id});
	}

	if (params->{action} eq 'delete_book'){
		$response =  Controller::delete_book_user(session('user'),params->{id});
	}
		header('Content-Type' => 'text/plain');
		header('Cache-Control' =>  'no-store, no-cache, must-revalidate');
		debug $response;
		return $response;
};


true;
