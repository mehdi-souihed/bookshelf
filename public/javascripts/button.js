$(document).ready(function(){

	$('input#myButton').click(function(){
		var id = $(this).attr('name');
		var action = ($(this).val() == 'Add Book') ? 'add_book' : 'delete_book' ;
		var response = '';
		$.ajax({
			type: "post",
			url: "/user/" + action,
			async: false,
			data: "id=" + id,
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
			$(this).val('Remove book');
		}


		if(response == 'deleted'){
			$(this).toggleClass("buttonDown");
			$(this).val('Add book');
		}


	});
});
