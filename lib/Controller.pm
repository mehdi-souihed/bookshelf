package Controller;


use strict;
use warnings ;
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

sub add_book_id {

 my $book = shift ;

 if(!is_a($book, 'Book')){
    die 'must have a Book object as parameter';
  }

 my $dbh = dbconnect();
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

sub add_user {

 my $user = shift ;

 if(!is_a($user, 'User')){
    die 'must have a User object as parameter';
  }
 
 my $dbh = dbconnect();
 $dbh->do('INSERT INTO user (fname,lname,email,password) VALUES (?,?,?,?)',
	 undef, $user->fname, $user->lname, $user->email, $user->md5_password);
	
 $dbh->disconnect;
}

sub add_book_user {
 my $user = shift;
 my $book = shift; # Book object
 my $status = 'unknown';
 my $category = 'unknown';
 my $rate = -1;
 my $tags = 'unknown';
 my $review = 'unknown';

# Insert the book in the book_id table
 add_book_id($book);

# Check for correct values in $user and $bookid ? TODO
 my $dbh = dbconnect();

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
 my $user = shift or die "You must specify a user";
 my $bookid = shift or die "You must specify a bookid";

 my $dbh = dbconnect();

 my $sql = 'DELETE FROM user_list WHERE googleid = ? AND userid = ?';
 my $sth = $dbh->prepare($sql);
 my $response = 'error while deleting';
 $response = 'deleted' if($sth->execute($bookid, $user)); 
 $dbh->disconnect;
 return $response; 
 
}

sub get_books_user{

 my $user = shift || 'mehdi@souihed.fr';

 my $dbh = dbconnect();

 my $sql = 'SELECT googleid FROM user_list WHERE userid = ?';
 my $sth = $dbh->prepare($sql);
 $sth->execute($user); 
 my $rows = $sth->fetchall_arrayref || '';
 $sth->finish;
 $dbh->disconnect;
 return $rows;
}

sub get_full_info_list_user{
 my $user = shift || 'mehdi@souihed.fr';

 my $dbh = dbconnect();

 my $sql =   'SELECT user_list.googleid, user_list.status, 
  		user_list.rate, user_list.review, book_id.author, 
		book_id.title, book_id.nb_pages, book_id.description, 
		book_id.categories, book_id.image_link, user_list.tags
	       	FROM user_list, book_id 
		WHERE user_list.userid = ? 
		AND user_list.googleid = book_id.googleid';
 my $sth = $dbh->prepare($sql);
 $sth->execute($user); 
 my $rows = $sth->fetchall_arrayref || '';
 $sth->finish;
 $dbh->disconnect;
 return $rows;
}	

sub login {
 my $email = shift ;
 my $passwd = shift;

 my $dbh = dbconnect();
 my $sql = 'SELECT password FROM user WHERE email = ?';
 my $sth = $dbh->prepare($sql);
 $sth->execute($email); 
 my $row = $sth->fetchrow_array || '';
 $sth->finish;
 $dbh->disconnect;
 return md5($passwd) eq $row ? 1 : 0;
};

sub tag_book{};
sub status_book{};

1;
