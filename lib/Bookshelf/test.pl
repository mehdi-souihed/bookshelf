#!/usr/bin/perl

use Controller;
use Book;

my $book = Book->new(
	
	title 	=> 'No Logo',
	author 	=> 'Naomi Klein',
	pages	=> '455',
	isbn	=> '12345',
	year	=> '1995',
	genre	=> 'political',
	url	=> 'http://www.google.com',
	link_image => 'http://www.google.com',
	status	=> 'read',
 	tags	=> 'chaos,political,agenda'	
);

Controller::add_book($book);
