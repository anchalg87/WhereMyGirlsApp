<?php


$parameter = $_SERVER['QUERY_STRING'];


$ugroupname = $_POST['gname'];
$ugrouppwd = $_POST['gpwd'];


$servername = "localhost";
$username = "root";
$password = "";
$dbname = "WMGA";
$title = "password check";
$message = "1";   // Success =1; Failure = 0;

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection

$pwdstatus = "select count(*) as count from Groupdetails where groupname='".$ugroupname."' and grppassword='".$ugrouppwd."'";


if ($conn->connect_error) {
   $result = array(
            'title' => $title,
    'msg' => "error"
);
echo stripslashes(json_encode($result));
} 
else
{
	$result = $conn->query($pwdstatus);
	$row = $result->fetch_assoc();
	
	$finalresult = array(
            'title' => $title,
    'msg' => $row["count"]
);
	
	echo stripslashes(json_encode($finalresult));
	}

$conn->close();
?>