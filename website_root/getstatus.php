<?php
$target = "status/" . $_GET["usr"] . ".txt";
if (file_exists($target ) {
echo readfile($target);
} else {
echo "No Record."
}
?>