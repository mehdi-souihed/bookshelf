package User;

use Moose;
use Digest::MD5;

has [qw (fname lname email)] => (
		is => 'rw',
		required => '1',
		isa => 'Str'
	       );

has 'user_password' => (
		is => 'rw',
		required => '1',
		isa => 'Str',
		trigger => \&_md5_hash
		);

has 'md5_password' => (
		is => 'rw',
		isa => 'Str',
		init_arg => undef
);


sub _md5_hash(){
	my ($self,$value) = @_;
	my $ctx = Digest::MD5->new;
	$ctx->add($value);
	$self->md5_password($ctx->digest);
}

1;
