
package Book;

use Moose;

has 'title'	=> (
		is => 'rw', 
		required => 1, 
		isa => 'Str');

has 'author' 	=> (
		is => 'rw', 
		required => 1,
		isa => 'Str');

has 'pages' 	=> (
	        is => 'rw', 
	      	required => 1,
	      	isa => 'Int');

has 'isbn' 	=> (
		is => 'rw', 
		required => 1,
		isa => 'Int');

has 'year' 	=>  (
		is => 'rw');

has 'genre' 	=>  (
		is => 'rw');

has 'url' 	=>  ( 
		is => 'rw');

has 'link_image' => (
		is => 'rw', 
		required => 1,
		isa => 'Str');

has 'status' 	=>  ( 
		is => 'rw', 
		required => 1,
		isa => 'Str');

has 'tags' 	=>  (
		is => 'rw');
1;
