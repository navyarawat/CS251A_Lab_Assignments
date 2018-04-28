<html>
<title> Homepage </title>

<script>
	function test_input($data) {
		$data = $data.trim();
		$data = $data.trim();
		//$data = $data.htmlspecialchars();
		return $data;
	}
	function verify(){
        //alert("0");
		var namejs = test_input(document.getElementById("name").value);
        //alert("1");
        //var addressjs = test_input(document.getElementById("address").value);
        //alert("2");
		var emailjs = test_input(document.getElementById("email").value);
        //alert("3");
		var mobilejs = test_input(document.getElementById("mobile").value);
        //alert("4");
		var accountjs = test_input(document.getElementById("account").value);
        //alert("5");
		var passwordjs = test_input(document.getElementById("password").value);
        //alert("6");

        var alphabetical = /^[a-zA-Z ]+$/;
    	var emaildotcom = /^[a-zA-Z]+@.+\.com$/;
        var numbers = /^[0-9]+$/;
        var alphanumeric = /^[0-9a-zA-Z]+$/;
    	if (alphabetical.test(namejs) == false) {
    		alert("Name must be in alphabets only");
    		return false;
    	}
    	if (emaildotcom.test(emailjs) == false) {
    		alert("email must be in .com only");
    		return false;
    	}
        if (numbers.test(mobilejs) == false) {
            alert("enter a valid mobile number");
            return false;
        }
        if (parseInt(mobilejs,10) < 1000000000) {
            alert("Mobile number should be 10 digits long.");
            return false;
        }
        if (numbers.test(mobilejs) == false) {
            alert("enter a valid account number");
            return false;
        }
        if (parseInt(accountjs,10) < 10000) {
            alert("Account number should be 5 digits long.");
            return false;
        }
        if (alphanumeric.test(passwordjs) == false) {
            alert("password can be alphanumeric only");
            return false;
        }
        return true;
    }
</script>

<h2>Register</h2>
<form name="registration" method="post" onsubmit="return verify();" action="adduser.php">
    Name <br><input type="text" name="name" id="name" maxlength="20" required> <br>
    Address <br><input type="text" name="address" id="address" maxlength="100" required> <br>
    Email <br><input type="email" name="email" id="email" required> <br>
    Mobile <br><input type="text" name="mobile" id="mobile" maxlength="10" required> <br>
    Account <br><input type="text" name="account" id="account" maxlength="5" required> <br>
    Password <br><input type="password" name="password" id="password" maxlength="20" required> <br><br>
    <input type="submit" name="submit" id="submit">
</form>

<a href="/read.php">View all registrations</a> <br>

</html>
