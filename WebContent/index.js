
$(document).ready(function(){
	var files;
	$('#file').on('change', 
	function prepareUpload(event){
	  files = event.target.files;
	  console.log(files);
	  console.log(files[0]);
	});
	
	$("#wrapper").submit(function(event){
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
		
		
		//$.post("http://192.168.1.120/printfile.php", formData, function(data){});
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
	        },
	        error: function(jqXHR, textStatus, errorThrown)
	        {
	        	// Handle errors here
	        	console.log('ERRORS: ' + textStatus);
	        	// STOP LOADING SPINNER
	        }
		});
	});
});