<?php
// Include the configuration file
   include('config.php');

   // Start the session
   session_start();
   
   // Get the user's session login username
   $user_check = $_SESSION['login_user'];
   
   // Query the database to get the user's username
   $ses_sql = mysqli_query($db,"select username from users where username = '$user_check' ");
   
   // Fetch the row as an associative array
   $row = mysqli_fetch_array($ses_sql,MYSQLI_ASSOC);
   
   // Extract the username from the fetched row
   $login_session = $row['username'];
   
   // Check if the user is not logged in, then redirect to signin page and terminate
   if(!isset($_SESSION['login_user'])){
      header("location: signin.php");
      die();
   }
