<?php
// Start the session
session_start();
?>

<nav>
        <a href="index.html">Home</a>
        <?php if (isset($_SESSION['login_user'])) { ?>
            <a href="logout.php">Logout</a>
        <?php } else { ?>
            <a href="signin.html">Login</a>
            <a href="signup.html">Register</a>
        <?php } ?>
    </nav>