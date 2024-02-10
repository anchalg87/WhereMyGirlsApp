<?php


$parameter = $_SERVER['QUERY_STRING'];

$uname= $_POST['uname'];
$uemail = $_POST['uemail'];
$upwd = $_POST['upwd'];
$uphone = $_POST['uphone'];
$uaptno = $_POST['uaptno'];
$uaddress = $_POST['uaddress'];
$uzipcode = $_POST['uzipcode'];




$servername = "localhost";
$username = "root";
$password = "";
$dbname = "WMGA";
$title = "RegistrationMessage";
$message = "1";   // SUccess =1; Failure = 0; Uname already exists =2;

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 

$check = "SELECT * FROM LoginDetails WHERE uemail= '$uemail'";
if ($conn->query($check) -> num_rows > 0) {
$result = array(
    
            'title' => $title,
    'msg' => "2"
);
echo stripslashes(json_encode($result));
}

else
{

$sql = "INSERT INTO LoginDetails (uname, upwd, uphone, uemail, aptno, address, zipcode)
VALUES ('$uname', '$upwd', $uphone, '$uemail', '$uaptno', '$uaddress', '$uzipcode')";

	if ($conn->query($sql) === TRUE) {
 	$result = array(
    
            'title' => $title,
    'msg' => $message
	);


	echo stripslashes(json_encode($result));
    
	} else {
   $result = array(
    
            'title' => $title,
    'msg' => "0"
	);


	echo stripslashes(json_encode($result));
}
}
$conn->close();
?>