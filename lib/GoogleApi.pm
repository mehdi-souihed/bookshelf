package GoogleApi;

use strict;
use warnings;

use LWP::UserAgent;
use Data::Dumper;
use URI::Escape;
use JSON; 

sub search_book{

	my $query = uri_escape(shift) || die "string query required for search_book";

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
	
	#print Dumper $results->{items};
	return $results->{items};

#	my @array_results;
#	foreach my $file (@{ $results->{items} }) {
#		push @array_results, $file->{volumeInfo}->{title};
#	}
       
}

#search_book('book');

1;
