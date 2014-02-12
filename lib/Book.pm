
package Book;

use Moose;
has [ qw /googleid nb_pages author title description image_link categories/] => (
		is => 'rw', 
		isa => 'Str');
1;
