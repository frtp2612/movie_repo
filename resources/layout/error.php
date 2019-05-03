<?php
http_response_code(404);
require_once( CLASSES_PATH . '/error.php'); // provide your own HTML for the error page

$error = new Error("404 Not Found");
$error -> printError();
die();
?>
