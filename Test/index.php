<html>
<title> WebPage </title>

<body>
<?php
    //print(1);
?>
    <h2>PHP SQLite</h2>
    <form method="post" action="adduser.php">
      Name: <input type="text" name="name">
      <br><br>
      E-mail: <input type="text" name="email">
      <br><br>
      Website: <input type="text" name="website">
      <br><br>
      Gender:
      <input type="radio" name="gender" value="female">Female
      <input type="radio" name="gender" value="male">Male
      <br><br>
      <input type="submit" name="submit" value="Submit">
    </form>
    <a href="table.php">See All Registrations</a>
</body>
</html>
