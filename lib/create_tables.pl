#! /usr/bin/perl -w

use strict;
use warnings;
use DBI;


#1. Create database
#2. Create book table
#3. Create user table 

sub create_user_table {

 my $database = shift || 'booky';
 my $username = shift || 'root';
 my $password = shift || 'pass';


 my $dbh = DBI->connect('DBI:mysql:'.$database, $username, $password
                   ) || die "Could not connect to database: $DBI::errstr";

=item
id,
title, 
author, 
pages, 
isbn, 
year, 
genre, 
url, 
link_image, 
status, 
tags

    warn "Could not create User table" unless ($dbh->do($sql));
=cut

my $sql = <<'END_SQL';
CREATE TABLE user (
id INTEGER PRIMARY KEY AUTO_INCREMENT,
fname VARCHAR(100),
lname VARCHAR(100),
email VARCHAR(100) UNIQUE NOT NULL,
password VARCHAR(255),
date timestamp default current_timestamp
)
END_SQL

    warn "Could not create User table" unless ($dbh->do($sql));

$dbh->disconnect;

}

create_user_table();
