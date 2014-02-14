$(document).ready(function(){

	$(':button').click(function(){
		var action = ($(this).val() == 'Add Book') ? 'add_book' : 'delete_book' ;
		var response = '';
		var args;

		if (action == 'add_book' && $(this).attr('id') == 'myButton'){
			args = {
			id : $(this).prev().attr('data-googleid'),
			nb_pages :  $(this).prev().attr('data-nbpages'),
			authors :  $(this).prev().attr('data-authors').trim(),
			title :  $(this).prev().attr('data-title'),
			desc :  $(this).prev().attr('data-desc'),
			image_link :  $(this).prev().attr('data-image_link'),
			categories :  $(this).prev().attr('data-categories').trim()
			};
		}

		if (action == 'add_book' && $(this).attr('id') == 'myListButton'){
			action = 'make_book_visible';
			args = {
				id : $(this).prev().attr('data-googleid')
			};
		}	
		if (action == 'delete_book' && $(this).attr('id') == 'myListButton'){
			action = 'make_book_invisible';
			args = {
				id : $(this).prev().attr('data-googleid')
			};
		}
		if (action == 'delete_book'){
			args = {
				id : $(this).prev().attr('data-googleid')
			};
		}
		$.ajax({
			type: "post",
			url: "/user/" + action,
			async: false,
			data:  args,
			error: function(httpRequest, message, errorThrown){
				alert (errorThrown);	
				throw errorThrown;
			},
			success: function (data) {
					 response = data;
				 }
		});

		if(response == 'added'|| response == 'duplicate'){
			$(this).toggleClass("buttonDown");
			$(this).val('Remove Book');
		}


		if(response == 'deleted'){
			$(this).toggleClass("buttonDown");
			$(this).val('Add Book');
		}


	});
});
