<?php


$parameter = $_SERVER['QUERY_STRING'];

$uemail = $_POST['uemail'];
$ugroup = $_POST['ugroup'];


$servername = "localhost";
$username = "root";
$password = "";
$dbname = "WMGA";
$title = "Members add to GroupMessage";
$message = "1";   // Success =1; Failure = 0;

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection

		$gminsert = "INSERT INTO GroupMemberdetails (groupname, uemail)
VALUES ('$ugroup', '$uemail')";
		
		if ($conn->query($gminsert) === TRUE) {
 		$result = array(
    
            'title' => $title,
    	'msg' => $message
		);
		echo stripslashes(json_encode($result));
		}
		
		else
		{
		$result = array(
    
            'title' => $title,
    	'msg' => "0"
		);
		echo stripslashes(json_encode($result));
		}

$conn->close();
?>