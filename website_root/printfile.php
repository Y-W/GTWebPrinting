<?php
$allowedExts = array("pdf");
$temp = explode(".", $_FILES["file"]["name"]);
$extension = end($temp);

if (in_array($extension, $allowedExts)) {
  if ($_FILES["file"]["error"] > 0) {
    echo "Return Code: " . $_FILES["file"]["error"] . "<br>";
  } else {
    echo "Upload: " . $_FILES["file"]["name"] . "<br>";
    echo "Type: " . $_FILES["file"]["type"] . "<br>";
    echo "Size: " . ($_FILES["file"]["size"] / 1024) . " kB<br>";
    echo "Temp file: " . $_FILES["file"]["tmp_name"] . "<br>";

      move_uploaded_file($_FILES["file"]["tmp_name"],
      "uploads/" . $_POST["usr"] . "-". $_POST["ptr"] . "-". $_FILES["file"]["name"]);
      echo "Stored in: " . "uploads/" . $_POST["usr"] . "-". $_POST["ptr"] . "-". $_FILES["file"]["name"];
    
  }
} else {
  echo "Invalid file";
}
?>