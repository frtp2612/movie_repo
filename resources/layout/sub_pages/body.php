<?php

  function displayPage($page) {
    $sub_page = $_GET['sub_page'];

    if($sub_page != ""){
      require_once( PAGES_PATH . '/' . $sub_page . '.php');
    } else {
      require_once($page);
    }
  }
?>
