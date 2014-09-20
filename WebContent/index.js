
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
			formData.append("file", value);
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
	        	alert("we received your files");
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
			console.log(data);
			$("#usrInfo").html(data);
		}, "text");
		
	});
	
});