$(document).ready(function(){

	$('input#myButton').click(function(){
		var id = $('input#myButton').attr('name');

		var response = '';
		$.ajax({
			type: "post",
			url: "/user/add_book",
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
		
		if(response == 1){
			$(this).toggleClass("buttonDown");
		}

	});
});
