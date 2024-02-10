<?php


$parameter = $_SERVER['QUERY_STRING'];


$uemail = $_POST['uname'];
$ugroupname = $_POST['gname'];

//$uemail = "sudheer123@gmail.com";

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "WMGA";
$title = "Notification Accepted";
$message = "1";   // Success =1; Failure = 0;

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection

$updatestatus = "UPDATE GroupMemberdetails SET status=1 where uemail='".$uemail."' and groupname='".$ugroupname."'";


if ($conn->connect_error) {
   $result = array(
            'title' => $title,
    'msg' => "0"
);
echo stripslashes(json_encode($result));
} 
else
{
	$result = $conn->query($updatestatus);
	
    $result = array(
            'title' => $title,
    'msg' => $message
);
echo stripslashes(json_encode($result));
    
}



$conn->close();
?>