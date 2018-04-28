<?php
require "index.php";

function test_input($data) {
  $data = trim($data);
  $data = stripslashes($data);
  $data = htmlspecialchars($data);
  return $data;
}

// Create connection
class MyDB extends SQLite3 {
    function __construct() {
        $this->open('mysqlitedb.db');
    }
}
$conn = new MyDB();
// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error . "<br>");
}

$table =<<<EOF
    CREATE TABLE IF NOT EXISTS users (
    name VARCHAR(20) NOT NULL,
    address VARCHAR(100) NOT NULL,
    email VARCHAR(50) NOT NULL PRIMARY KEY,
    mobile INT(10) NOT NULL,
    account INT(5) NOT NULL,
    password VARCHAR(20) NOT NULL
    );
EOF;

$check = $conn->exec($table);
if(!$check){
    die($conn->lastErrorMsg());
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $name = test_input($_POST['name']);
    $email = test_input($_POST['email']);
    $address = test_input($_POST['address']);
    $account = test_input($_POST['account']);
    $mobile = test_input($_POST['mobile']);
    $password = test_input($_POST['password']);

    $findemail = exec("SELECT * FROM records WHERE email='$email'");
    if (!empty($findemail)) {
        echo "user already exists";
    }
    else {
        echo "adding new user....<br>";
        //echo $name . "<br>";
        //echo $email . "<br>";
        //echo $address . "<br>";
        $qstr = "INSERT INTO records (name, address, email, mobile, account, password)
                values ('$name', '$address', '$email', '$mobile', '$account', '$password')";
        $insres = exec($qstr);
        //echo $insres . "lalala<br>";
        if ($insres === TRUE) {
            echo "New record created successfully";
        } else {
            echo "Error: " . $insres . "<br>" . $conn->error;
        }
    }
}
?>
