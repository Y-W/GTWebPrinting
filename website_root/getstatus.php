<?php
$target = "status/" . $_GET["usr"] . ".txt";
if (file_exists($target) ) {
readfile($target);
} else {
echo "No Record.";
}
?>