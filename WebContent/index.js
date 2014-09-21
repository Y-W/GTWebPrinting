
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
	        processData: false, // Don't process the files
	        contentType: false,
	        success: function(data, textStatus, jqXHR)
	        {
	        	console.log("we received your files");
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
	        	$('#successMessage').html("File uploaded");
	        	// Handle errors here
	        	console.log('ERRORS: ' + textStatus);
	        	// STOP LOADING SPINNER
	        }
		});
	});
	
	$("#queryWrapper").submit(function(){
		event.preventDefault();
		$('#successMessage').empty();
		$.get("no.text", $("#queryWrapper").serialize(), function(data){
			$("#jobs").remove();
			console.log(data);
			//$("#usrInfo").html(data);
			var strings = data.split("\n");
			var words;
			var fileName = "";
			var status = "";
			var i = 1;
			var tableType = "table table-hover";
			$("<table id=jobs></table>").insertAfter('#queryWrapper');
			$('#jobs').attr("class", tableType);
			$('#jobs').wrapInner("<tbody id=wrapper><tr><th>Job Number</th><th>Files</th><th>Status</th></tr></tbody>");
			$.each(strings, function(key, value){
				words = value.split(" ");
				$.each(words, function(key, value) {
					if (key == 0) {
						fileName = value;
					}
					if (key >= 2) {
						status += (value + " ");
					}
				});
				$("<tr><td align=center>" + i + "</td><td>" + fileName + "</td><td>" + status + "</td></tr>").insertAfter('#jobs tr:first');
				i++;
				console.log(fileName);
				console.log(status);
				filename = "";
				status = "";
			});
			console.log($.type(data));
		}, "text");
		
	});
	
});