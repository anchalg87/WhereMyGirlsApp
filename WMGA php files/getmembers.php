<?php


$parameter = $_SERVER['QUERY_STRING'];


$useremail = $_POST['uemail'];

//$useremail = "sudheer123@gmail.com";

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "WMGA";
$title = "MembersMessage";
$message = "1";   // Success =1; Failure = 0;

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection

$getmemnames = "SELECT uemail FROM Logindetails where uemail <>'".$useremail."'";


if ($conn->connect_error) {
   $result = array(
            'title' => $title,
    'msg' => "0"
);
echo stripslashes(json_encode($result));
} 
else
{
	$result1 = $conn->query($getmemnames);
	$i = 0;
	$result = array();
	 while ($row = $result1->fetch_assoc()) {
	   $i++;
       $result = $result + array($i => $row['uemail'] );
    }
    
echo stripslashes(json_encode($result));
    
}



$conn->close();
?>