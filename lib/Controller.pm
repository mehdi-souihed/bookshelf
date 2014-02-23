package Controller;

use Moose;
use DBI;
use User;
use Book;

sub is_a{
 my $self = shift; 
 my $object = shift;
 my $expected = shift;
 return ref($object) eq $expected ? 1 : 0;
}

sub dbconnect {

 my $self = shift;
 my $database = shift || 'booky';
 my $username = shift || 'root';
 my $password = shift || 'pass';
 return DBI->connect('DBI:mysql:'.$database, $username, $password
                   ) || die "Could not connect to database: $DBI::errstr";
}





1;
