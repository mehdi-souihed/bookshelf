package Controller::User;

use Moose;
use lib '..';
use User;
use Digest::MD5 qw (md5);

extends 'Controller';

sub add_user {
 
 my ($self,$user) = @_ ;

 if(!$self->is_a($user, 'User')){
    die 'must have a User object as parameter';
  }
 
 my $dbh = $self->dbconnect();
 $dbh->do('INSERT INTO user (fname,lname,email,password) VALUES (?,?,?,?)',
	 undef, $user->fname, $user->lname, $user->email, $user->md5_password);
	
 $dbh->disconnect;
}

#TODO
sub remove_user{}

sub get_full_info_list_user{
 my $self = shift;
 my $user = shift || 'mehdi@souihed.fr';

 my $dbh = $self->dbconnect();

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
 my $self = shift;	
 my $email = shift ;
 my $passwd = shift;

 my $dbh = $self->dbconnect();
 my $sql = 'SELECT password FROM user WHERE email = ?';
 my $sth = $dbh->prepare($sql);
 $sth->execute($email); 
 my $row = $sth->fetchrow_array || '';
 $sth->finish;
 $dbh->disconnect;
 
 return md5($passwd) eq $row ? 1 : 0;
};
1;
