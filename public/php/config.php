<?php

$config = array(
	"dbname" => "imsdb",
	"username" => "root",
	"password" => "grzk9v3wh97",
	"host" => "localhost"
);

function connect(){
	global $config;

	$connect = mysql_connect($config["host"],$config['username'],$config['password']);
	if(!$connect){
		die ('Unable to connect: '.mysql_error());
	}

	$selectDB= mysql_select_db($config['dbname']);
	if(!$selectDB){
		die ('Error in the database selection: '.mysql_error());
	} else {
		//echo "it works";
	}
}

connect();


defined("LIBRARY_PATH")
    or define("LIBRARY_PATH", realpath(dirname(__FILE__) . '/library'));

defined("ROOT_PATH")
  or define("ROOT_PATH", dirname(dirname(__FILE__)) . '/' );

defined("PUBLIC_PATH")
  or define("PUBLIC_PATH", '/public' );

defined("RESOURCES_PATH")
  or define("RESOURCES_PATH", '/resources' );

defined("LAYOUT_PATH")
  or define("LAYOUT_PATH", RESOURCES_PATH . '/layout' );

defined("TEMPLATES_PATH")
    or define("TEMPLATES_PATH", LAYOUT_PATH . '/sub_pages');

defined("PAGES_PATH")
    or define("PAGES_PATH", RESOURCES_PATH . '/web_pages');

defined("CLASSES_PATH")
    or define("CLASSES_PATH", PAGES_PATH . '/classes');

defined("IMAGES_PATH")
    or define("IMAGES_PATH", PUBLIC_PATH . '/images');

defined("USERS_PATH")
    or define("USERS_PATH", IMAGES_PATH . '/users');

defined("PHP_PATH")
    or define("PHP_PATH", PUBLIC_PATH . '/php');


ini_set("error_reporting", "true");


setlocale(LC_TIME, 'ita', 'it_IT.utf8');
$date = date("Y-m-d H:i:s");

function cryptData( $string, $action = 'e' ) {

    $secret_key = '3klmsd94mms';
    $secret_iv = 'saeo44o';

    $output = false;
    $encrypt_method = "AES-256-CBC";
    $key = hash( 'sha256', $secret_key );
    $iv = substr( hash( 'sha256', $secret_iv ), 0, 16 );

    if( $action == 'e' ) {
        $output = base64_encode( openssl_encrypt( $string, $encrypt_method, $key, 0, $iv ) );
    }
    else if( $action == 'd' ){
        $output = openssl_decrypt( base64_decode( $string ), $encrypt_method, $key, 0, $iv );
    }

    return $output;
}
?>
