<?php


$parameter = $_SERVER['QUERY_STRING'];


$uemail = $_POST['uname'];

//$uemail = "sudheer123@gmail.com";

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "WMGA";
$title = "MembersMessage";
$message = "1";   // Success =1; Failure = 0;

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection

$getcount = "SELECT count(*) as count FROM GroupMemberdetails where uemail ='".$uemail."' and status = 0";


if ($conn->connect_error) {
   $result = array(
            'title' => $title,
    'msg' => "0"
);
echo stripslashes(json_encode($result));
} 
else
{
	$result = $conn->query($getcount);
	$row = $result->fetch_assoc();
	
	$finalresult = array(
            'title' => $title,
    'msg' => $row["count"]
);
	
	echo stripslashes(json_encode($finalresult));
 

    
}



$conn->close();
?>