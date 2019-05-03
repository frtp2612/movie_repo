<?php

    function renderLayoutWithContentFile($contentFile)
    {

      $contentFileFullPath = PAGES_PATH . "/" . $contentFile;

      require_once ( TEMPLATES_PATH . "/header.php" );

      if (file_exists($contentFileFullPath)) {

        require_once ( TEMPLATES_PATH . "/body.php" );

        displayPage ( $contentFileFullPath );

      } else {

        require_once ( LAYOUT_PATH . "/error.php" );

      }

      require_once( TEMPLATES_PATH . "/footer.php" );
    }
?>
