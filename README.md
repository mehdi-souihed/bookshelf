# Bookshelf


## Description
A Perl application running on Dancer to keep track of your books using Google Books API

You can  :

 - Create lists of books
 - Put tags on your books
 - Give a status to your books (read, to read, currently reading)
 - Write a review on a book
 - Add up the pages of the books you have read
 - Make statistics per month/year/week
 - Send a summary of your reading list via mail/Facebook
 - Request suggestions of reads based on what you have previously read

## Prerequisites

Mysql V5 or superior

## Test your install



## How to install

Feed the configuration file with your database username and password.

run the lib/create_tables.pl script

You have to run Dancer first :

perl bin/app.pl

Then go to the Home page :

http://localhost:3000/bookshelf

and create an account
