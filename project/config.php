<?php


function getConnection() {
    $db = mysqli_connect('localhost', 'root', 'root', 'anmoldb');
    return $db;
}


