<?php
include('session.php');
?>
<!--Html starts -->
<!DOCTYPE html>
<html lang="en">

<head>
    <link rel="stylesheet" href="assets/css/index-styles.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>

<body>

    <!-- restricted page -->
<?php include('nav.php'); ?>
<!--haeder starts -->
    <header>
        <h1>Welcome to Dashboard, <u><mark><?php echo $_SESSION['login_user']; ?></mark></u></h1>
        <p>You Can Edit Post in this page.</p>
    </header>

    <main>
        <div class="card">
            <h2>What is HTML?</h2>
            <img src="assets/images/img_5terre.jpg" class="card-img">
            <h5>Published on 27 June 2023 | Published by Author</h5>
            <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Maiores quisquam, eligendi facilis vitae quibusdam ipsam fuga doloribus velit, at eos dolorem optio asperiores. Officia autem unde...</p>
        </div>


        <div class="card">
            <h2>What is CSS?</h2>
            <img src="assets/images/img_forest.jpg" class="card-img">
            <h5>Published on 28 June 2023 | Published by Author</h5>
            <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Maiores quisquam, eligendi facilis vitae quibusdam ipsam fuga doloribus velit, at eos dolorem optio asperiores. Officia autem unde...</p>
        </div>
    </main>
</body>

</html>