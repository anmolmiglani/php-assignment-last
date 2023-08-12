<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
session_start();
include("config.php");

$error = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // username and password sent from form 
    $db = getConnection();
    $myusername = mysqli_real_escape_string($db, $_POST['username']);
    $mypassword = mysqli_real_escape_string($db, $_POST['password']);

    $sql = "SELECT * FROM users WHERE username = '$myusername'";

    $result = mysqli_query($db, $sql);
    $row = mysqli_fetch_assoc($result);

    if (is_null($row)) {
        $error = "Invalid Username $myusername";
    } else {
        $count = mysqli_num_rows($result);
        $pass_verify = password_verify($mypassword, $row['password']);

        // If result matched $myusername and $mypassword, table row must be 1 row

        if (($count == 1) && ($pass_verify)) {

            $_SESSION['login_user'] = $myusername;

            header("location: index.php");
        } else {
            $error = "Your Login Name or Password is invalid";
        }
    }
}
?>


<!DOCTYPE html>
<html lang="en">

<head>
    <link rel="stylesheet" href="assets/css/login-styles.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>

<body id="signin-body">


    <form method="POST">
        <div class="form-label">Please Login</div>
        <div class="form-group">
            <input type="text" name="username" placeholder="Enter Username" autofocus required>
        </div>
        <div class="form-group">
            <input type="text" name="password" placeholder="Enter Password" required>
        </div>
        <div class="form-group">
            <input type="submit" value="Login">
        </div>
        <div class="status"><?php echo $error;  ?></div>

        <div>Do you want to <a href="signup.php">REGISTER?</a></div>

    </form>
</body>

</html>