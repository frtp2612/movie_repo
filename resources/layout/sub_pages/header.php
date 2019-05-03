<?php
   $menuItems = array ("Home", "Shows List", "Popular Shows", "Movies", "New Shows", "Login", "Register");
?>

<html lang="en">
<head>
    <meta http-equiv='Content-Type' content='text/html; charset=utf-8'>
    <title>Test Site</title>
    <base href="http://www.imsproject.com/" />
    <script src='https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js'></script>
    <script src='http://code.jquery.com/jquery-1.10.2.js' type='text/javascript'></script>
    <script src='http://code.jquery.com/ui/1.11.2/jquery-ui.js' type='text/javascript'></script>
    <link href='public/css/style.css' rel="stylesheet" type="text/css">
    <link href='public/css/header.css' rel="stylesheet" type="text/css">
    <link href='public/css/body.css' rel="stylesheet" type="text/css">
    <link href='public/css/sub_pages/home.css' rel="stylesheet" type="text/css">
    <script src='public/js/functions.js' type='text/javascript'></script>
</head>

<body>

<?php
$genreQuery = mysql_query("SELECT * FROM genre");
echo "
<div class='leftPanel'>

  <img class='logo' src='public/images/layout/logo.svg'>

  <div class='filters'>
  <span class='filterName'>Genre</span>
  <div class='selector' name='genre'>
    <span onclick='selector(this);'>Genre</span>
    <ul value='genre'>";

    while($genreArray = mysql_fetch_array($genreQuery)) {
      $genreId = $genreArray['id'];
      $genreName = $genreArray['name'];
      echo "<li value='$genreId' onclick='select(this);'>$genreName</li>";
    }

echo "
    </ul>
  </div>
  <div class='genre'></div>

  <span class='filterName'>Cinema</span>
  <div class='multi-select'>
    <ul>
      <li onclick='multi(this);' class='2-cols'>UCI</li>
      <li onclick='multi(this);' class='2-cols'>Cineplexx</li>
    </ul>
  </div>

  <span class='filterName'>Price Range</span>
  <div class='rangeSlider'>
    <input type='text' class='range' placeholder='Min' maxlength='4'>
    <input type='text' class='range' placeholder='Max' maxlength='4'>
  </div>

  <span class='filterName'>Age</span>
  <div class='multi-select'>
    <ul>
      <li onclick='multi(this);' class='5-cols'>S</li>
      <li onclick='multi(this);' class='5-cols'>7</li>
      <li onclick='multi(this);' class='5-cols'>12</li>
      <li onclick='multi(this);' class='5-cols'>16</li>
      <li onclick='multi(this);' class='5-cols'>18</li>
    </ul>
  </div>

  <span class='filterName'>Dimensions</span>
  <div class='multi-select'>
    <ul>
      <li onclick='multi(this);' class='2-cols'>2D</li>
      <li onclick='multi(this);' class='2-cols'>3D</li>
    </ul>
  </div>

  </div>
</div>

<div class='menu'>
  <div class='search'>
    <input type='search' placeholder='Type to search..'>
    <button><img src='public/images/layout/search.svg'></button>
  </div>
</div>
";
?>
