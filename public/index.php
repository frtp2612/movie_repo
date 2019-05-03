<?php
  /*includes the template file.
  *
  * It contains the structure of the site.
  *
  */
  require_once ( LAYOUT_PATH . "/template.php");

  $page = $_GET['page'] . ".php";
  if($page == ".php"){
    $page = "home.php";
  }

  /*
  *
  * This method checks the page value and renders the code of
  * the associated file.
  *
  */
  renderLayoutWithContentFile($page);

?>
