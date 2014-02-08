package Controller;

use strict;
use warnings;

use Moose;
use DBI;
use User;
use Book;
use Data::Dumper;
use Digest::MD5 qw (md5);

sub is_a{
 
 my $object = shift;
 my $expected = shift;
 return ref($object) eq $expected ? 1 : 0;
}

sub dbconnect {

 my $database = shift || 'booky';
 my $username = shift || 'root';
 my $password = shift || 'pass';
 return DBI->connect('DBI:mysql:'.$database, $username, $password
                   ) || die "Could not connect to database: $DBI::errstr";
}

sub add_book {

 my $book = shift ;

 if(!is_a($book, 'Book')){
    die 'must have a Book object as parameter';
  }
 
 my $dbh = dbconnect();
 my $sth = $dbh->do('INSERT INTO books (title, author, pages, isbn, year, genre, url, link_image, status, tags,time) VALUES (?,?,?,?,?,?,?,?,?,?)',undef, $book->title, $book->author, $book->pages, $book->isbn, $book->year, $book->genre, $book->url, $book->link_image, $book->status, $book->tags,time);
	
$dbh->disconnect;
}

sub add_user {

 my $user = shift ;

 if(!is_a($user, 'User')){
    die 'must have a User object as parameter';
  }
 
 my $dbh = dbconnect();
 my $sth = $dbh->do('INSERT INTO user (fname,lname,email,password) VALUES (?,?,?,?)',undef, $user->fname, $user->lname, $user->email, $user->md5_password);
	
 $dbh->disconnect;
}

sub login {
 my $email = shift ;
 my $passwd = shift;

 my $dbh = dbconnect();
 my $sql = 'SELECT password FROM user WHERE email = ?';
 my $sth = $dbh->prepare($sql);
 $sth->execute($email); 
 my $row = $sth->fetchrow_array || '';
 return md5($passwd) eq $row ? 1 : 0;
};

sub remove_book{};
sub search_book{};
sub tag_book{};
sub add_book_list{};
sub status_book{};

1;
