<?php
	function endsWith($haystack, $needle) {
		// search forward starting from end minus needle length characters
		return $needle === "" || (($temp = strlen($haystack) - strlen($needle)) >= 0 && strpos($haystack, $needle, $temp) !== false);
	}
	$mode = urldecode($_GET['mode']);

	require 'config.php';

	$courseId = urldecode($_GET['courseId']);
	$login_url = $moodle_url.(!endsWith($moodle_url, "/")?"/":"")."login/index.php";
	$course_url = $moodle_url.(!endsWith($moodle_url, "/")?"/":"")."course/view.php?idnumber=".$courseId;

	if($mode == "login")  {
		// attempt automatic login to moodle
		require 'config.php';
		$username = urldecode($_GET['username']);
		$password = urldecode($_GET['password']);
		$invalidate_nonce_url = $moodle_url.(!endsWith($moodle_url, "/")?"/":"")."noncelogin/login.php";
?>
		<html>
		<head>
		<script type='text/javascript' src='jquery-2.2.3.min.js'></script>
		<script type='text/javascript' src='js.cookie-2.1.1.min.js'></script>
		</head>
		<body>
		<script>
			var login_failed = false;
					debugger;
			$.ajax({
				url: "<?php echo $login_url?>",
				type: "POST", 
				data: "username=<?php echo $username?>&password=<?php echo $password?>", 
				async: false, 
				success:  function(result){
					login_failed = result.indexOf("loginerrormessage") > -1;
					debugger;
					if(login_failed) {
						Cookies.remove('MoodleSession');
						alert( "Login failed. Please login manually" );
					}
					invalidate_nonce();
				}, 
				error: function(result){
					debugger;
					alert( "Login failed. Please login manually" );
					invalidate_nonce();
				}
			});
			
			function invalidate_nonce() {
				window.location.href = "<?php echo $invalidate_nonce_url?>?username=<?php echo $username?>&mode=invalidate&courseId=<?php echo $courseId?>";
			}
		</script>
		</body>
		</html>
<?php
	} else if($mode == "invalidate")  {
		// replace nonce with the user's normal password
		$username = urldecode($_GET['username']);
		$conn = new mysqli($db_servername, $db_username, $db_password, $db_database);
	
		if ($conn->connect_error) {
			die("Connection failed: " . $conn->connect_error);
		}
	
		if($stmt = $conn->prepare('UPDATE user SET moodle_password = NULL WHERE username = ?')) {
			$stmt->bind_param('s', $username);
			$stmt->execute();
			
			/* close statement */
			$stmt->close();
		}
		/* close connection */
		$conn->close();
		
		// redirect to home page
		header("Location: ".$course_url, true, 302);
	}
?>

