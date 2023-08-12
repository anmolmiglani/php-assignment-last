<?php
// Settng some error reporting to display errors
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Including the configuration file
require('config.php');

$usernameErr = $password1Err = $password2Err = "";
$username = $password1 = $password2 = "";
$status = "";

// Functioning to sanitize and escape input data
function test_input($data)
{
    $db = getConnection();
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);
    $data = mysqli_real_escape_string($db, $data);
    return $data;
}

// Validating and sanitize username
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $db = getConnection();
    if (empty($_POST['username'])) {
        $usernameErr = "Username is required!";
    } else {
        $username = test_input($_POST['username']);
    }

    // Validating and sanitize confirm password
    if (empty($_POST['password1'])) {
        $password1Err = "Password is required!";
    } else {
        $password1 = test_input($_POST['password1']);
    }

    if (empty($_POST['password2'])) {
        $password2Err = "Confirm Password is required!";
    } else {
        $password2 = test_input($_POST['password2']);
    }

    // Check if passwords match
    if ($password1 != $password2) {
        $password1Err = "Passwords didn't Match";
        $password2Err = "Passwords didn't Match";
    }

     // If no errors, insert user into database
    if (empty($password1Err) && empty($password2Err) && empty($usernameErr)) {
        $password = password_hash($password1, PASSWORD_BCRYPT);
        $sql = "insert into users (username, password) values ('$username', '$password')";

        if (mysqli_query($db, $sql)) {
            $status = "You are Registered";
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
        <div class="form-label">Please Signup</div>
        <div class="form-group">
            <input type="text" name="username" placeholder="Enter Username" autofocus value="<?php echo $username; ?>">
            <span class="error">* <?php echo $usernameErr; ?></span>
        </div>


        <div class="form-group">
            <input type="text" name="password1" placeholder="Enter Password" value="<?php echo $password1; ?>">
            <span class="error">* <?php echo $password1Err; ?></span>
        </div>


        <div class="form-group">
            <input type="text" name="password2" placeholder="Confirm Password" value="<?php echo $password2; ?>">
            <span class="error">* <?php echo $password2Err; ?></span>
        </div>


        <div class="form-group">

            <input type="submit" name="btn" value="Register">
        </div>

        <br>
        <div class="status"><?php echo $status;  ?></div>

        <div>Do you want to <a href="signin.php">Login?</a></div>

    </form>
</body>

</html>