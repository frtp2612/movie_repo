<?php
class Error {

	private $error;

    public function __construct($error) {
        $this -> error = "<div class='error'>" . $error . "</div>";
    }

    function printError() {
    	echo $this -> error;
    }
}
?>
