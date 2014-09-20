
$(document).ready(function(){
	var files;
	$('#file').on('change', 
	function prepareUpload(event){
	  files = event.target.files;
	  console.log(files);
	  console.log(files[0]);
	});
	
	$("#releaseWrapper").submit(function(event){
		event.preventDefault();
		console.log("ajax submit");
		var formData = new FormData();
		formData.append("usr", $("#usr").val());
		formData.append("ptr", $('#ptr').val());
		$.each(files, function(key, value)
		{
<<<<<<< HEAD
			formData.append("file", value);
=======
					formData.append("file", value);
>>>>>>> 91a5c6919973eb5de1885742051961217be3d49a
		});
		console.log(formData);
		
		$.ajax({
	        url: 'printfile.php',
	        type: 'POST',
	        data: formData,
	        cache: false,
	        dataType: 'json',
	        processData: false, // Don't process the files
	        contentType: false,
	        success: function(data, textStatus, jqXHR)
	        {
	        	if(typeof data.error === 'undefined')
	        	{
	        		// Success so call function to process the form
	        		submitForm(event, data);
	        	}
	        	else
	        	{
	        		// Handle errors here
	        		console.log('ERRORS: ' + data.error);
	        	}
	        	alert("we received your files");
	        },
	        error: function(jqXHR, textStatus, errorThrown)
	        {
	        	// Handle errors here
	        	console.log('ERRORS: ' + textStatus);
	        	// STOP LOADING SPINNER
	        }
		});
	});
	
	$("#queryWrapper").submit(function(){
		event.preventDefault();
		$.get("getstatus.php", $("#queryWrapper").serialize(), function(data){
			$("#usrinfo").html(data);
		}, "text");
		
	});
	
});