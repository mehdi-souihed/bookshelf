package GoogleApi;

use strict;
use warnings;
use v5.10;

use LWP::UserAgent;
use Data::Dumper;
use URI::Escape;
use JSON; 
use Controller;

sub search_book{

	my $query = uri_escape(shift) || die "string query required for search_book";
	my $userid = shift;

	my $ua = LWP::UserAgent->new;
	$ua->agent('Mozilla/5.0');

#TODO change to accept hash as parameter
	my $req = HTTP::Request->new(GET => "https://www.googleapis.com/books/v1/volumes?q=$query");
	$req->content_type('text/xml, charset=utf-8');

# Pass request to the user agent and get a response back
	my $res = $ua->request($req);

# Check the outcome of the response
	die $res->status_line if (!$res->is_success) ; 

	my $results = decode_json($res->decoded_content);

	my $list = Controller::get_books_user($userid);
	my @flat_list = map {@$_} @$list;
	my %tmp = @{$results->{items}};
	#my @tmp  = map {$_->{id} ~~ @flat_list?  ($_->{status} = 1) : ($_->{status} = 0)}   @{$results->{items}};
	#my %tmp  = map {$_->{id} ~~ @flat_list? 'inlist' => 'yes': 'inlist' => 'no' }   @{$results->{items}};
	foreach ( @{$results->{items}}) {
		 if( $_->{id} ~~ @flat_list){
			$_->{inlist} = 'true';
		 }
	}
	#print Dumper $results;
	return $results->{items};

#	my @array_results;
#	foreach my $file (@{ $results->{items} }) {
#		push @array_results, $file->{volumeInfo}->{title};
#	}
       
}

#search_book('sprout');

1;
