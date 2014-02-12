#! /usr/bin/perl -w

use strict;
use warnings;
use DBI;

#1. Create database
#2. Create book table
#3. Create user table 

sub create_tables {

 my $database = shift || 'booky';
 my $username = shift || 'root';
 my $password = shift || 'pass';


 my $dbh = DBI->connect('DBI:mysql:'.$database, $username, $password
                   ) || die "Could not connect to database: $DBI::errstr";

my $sql = <<'END_SQL';
CREATE TABLE book_id (
id INTEGER PRIMARY KEY AUTO_INCREMENT,
googleid VARCHAR(100) UNIQUE NOT NULL,
nb_pages INTEGER, 
author VARCHAR(255),
title VARCHAR(255),
description VARCHAR(3000),
image_link VARCHAR(255),
categories VARCHAR(255), 
date timestamp default current_timestamp
)
END_SQL

    warn "Could not create book_id table" unless ($dbh->do($sql));

 $sql = <<'END_SQL';
CREATE TABLE user_list (
id INTEGER PRIMARY KEY AUTO_INCREMENT,
userid VARCHAR(100),
googleid VARCHAR(100),
status VARCHAR(100),
category VARCHAR(100),
rate INTEGER,
tags  VARCHAR(255),
review VARCHAR(5000),
date timestamp default current_timestamp
)
END_SQL

    warn "Could not create user_list table" unless ($dbh->do($sql));

 $sql = <<'END_SQL';
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

create_tables();
