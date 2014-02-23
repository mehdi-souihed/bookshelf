package Controller::Book;

use Moose;
use lib '..';
use Book;

extends 'Controller';

sub add_book_id {
 my $self = shift;
 my $book = shift ;

 if(!$self->is_a($book, 'Book')){
    die 'must have a Book object as parameter';
  }

 my $dbh = $self->dbconnect();
 my $res = eval {
         no warnings; 
	 $dbh->do('INSERT IGNORE INTO book_id 
		 (googleid, nb_pages, author,
		 title, description,image_link,categories) 
		 VALUES (?,?,?,?,?,?,?)',  
		 undef,
		 $book->googleid,
		 $book->nb_pages,
		 $book->author,
		 $book->title,
		 $book->description,
		 $book->image_link,
		 $book->categories
	 )
 };

 unless ($res) {
	 warn "ERROR in DBI: ".$@ if ($@ !~ /Duplicate/i);
 }
 
 $dbh->disconnect;
}

sub add_book_user {
 my $self = shift;
 my $user = shift;
 my $book = shift; # Book object
 my $status = 'unknown';
 my $category = 'unknown';
 my $rate = -1;
 my $tags = 'unknown';
 my $review = 'unknown';

# Insert the book in the book_id table
 $self->add_book_id($book);

# Check for correct values in $user and $bookid ? TODO
 my $dbh = $self->dbconnect();

# Checking that the book is not already in the user list 
 my $sql = 'SELECT * FROM user_list WHERE googleid = ? AND userid = ? ';
 my $sth = $dbh->prepare($sql);
 $sth->execute($book->googleid, $user); 
 my $row = $sth->fetchrow_array || '';
 $sth->finish;
 
 my $r = 'duplicate';
 if($row eq ''){
 $dbh->do('INSERT INTO user_list 
	 (userid,googleid,status,category,rate,tags,review) 
	 VALUES (?,?,?,?,?,?,?)', undef, $user, $book->googleid, 
	 $status,$category,$rate,$tags,$review);
  my $r = 'added';
 }
 $dbh->disconnect; 
 return $r;
}

sub delete_book_user {
 my $self = shift;
 my $user = shift or die "You must specify a user";
 my $bookid = shift or die "You must specify a bookid";

 my $dbh = $self->dbconnect();

 my $sql = 'DELETE FROM user_list WHERE googleid = ? AND userid = ?';
 my $sth = $dbh->prepare($sql);
 my $response = 'error while deleting';
 $response = 'deleted' if($sth->execute($bookid, $user)); 
 $dbh->disconnect;
 return $response; 
 
}

sub get_books_user{
 my $self = shift;
 my $user = shift || 'mehdi@souihed.fr';

 my $dbh = $self->dbconnect();

 my $sql = 'SELECT googleid FROM user_list WHERE userid = ?';
 my $sth = $dbh->prepare($sql);
 $sth->execute($user); 
 my $rows = $sth->fetchall_arrayref || '';
 $sth->finish;
 $dbh->disconnect;
 return $rows;
}

sub tag_book{};
sub status_book{};
1;
