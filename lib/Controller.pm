package Controller;

use strict;
use warnings;

use Moose;
use DBI;

use Book;

sub is_book{
 
 my $object = shift;
 return ref($object) eq 'Book'? 1 : 0;
}

sub add_book {

 my $book = shift ;
 my $database = shift || 'booky';
 my $username = shift || 'root';
 my $password = shift || 'pass';

 if(!is_book($book)){
    die 'create_tables must have a Book object as parameter';
  }
 
 my $dbh = DBI->connect('DBI:mysql:'.$database, $username, $password
                   ) || die "Could not connect to database: $DBI::errstr";
 my $sth = $dbh->do('INSERT INTO books (title, author, pages, isbn, year, genre, url, link_image, status, tags) VALUES (?,?,?,?,?,?,?,?,?,?)',undef, $book->title, $book->author, $book->pages, $book->isbn, $book->year, $book->genre, $book->url, $book->link_image, $book->status, $book->tags);
	
$dbh->disconnect;
}

sub remove_book{};
sub search_book{};
sub tag_book{};
sub add_book_list{};
sub status_book{};

1;
