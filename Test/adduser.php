#php -S localhost:8000
<?php
require "index.php";
function test_input($data) {
  $data = trim($data);
  $data = stripslashes($data);
  $data = htmlspecialchars($data);
  return $data;
}

// Create connection
$conn = new SQLite3('mydb.db');
// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error . "<br>");
}

$table = "CREATE TABLE IF NOT EXISTS users (
    name VARCHAR(20) NOT NULL,
    email VARCHAR(50) NOT NULL PRIMARY KEY,
    website VARCHAR(20) NOT NULL,
    gender VARCHAR(20) NOT NULL
    );";

$check = $conn->query($table);
if(!$check){
    die($conn->lastErrorMsg());
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $name = test_input($_POST['name']);
    $email = test_input($_POST['email']);
    $website = test_input($_POST['website']);
    $gender = test_input($_POST['gender']);

    $findemail = $conn->query("SELECT COUNT(*) FROM users WHERE email='$email'");
    $result = $findemail->fetchArray();
    if ($result[0] != 0) {
        echo "user already exists";
    }
    else {
        echo "adding new user....<br>";
        //echo $name . "<br>";
        //echo $email . "<br>";
        //echo $address . "<br>";
        $qstr = "INSERT INTO users values ('$name', '$email', '$website', '$gender')";
        $insres = $conn->query($qstr);
        //echo $insres . "lalala<br>";
        if ($insres == TRUE) {
            echo "New record created successfully";
        } else {
            echo "Error: " . $insres . "<br>" . $conn->error;
        }
    }
}
?>
