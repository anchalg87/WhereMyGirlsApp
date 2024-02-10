<?php


$parameter = $_SERVER['QUERY_STRING'];


$uemail = $_POST['uname'];
$ugroupname = $_POST['gname'];

// $uemail = "sudheer123@gmail.com";
// $ugroupname = "friends";


$servername = "localhost";
$username = "root";
$password = "";
$dbname = "WMGA";
$title = "admin status of group";


// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection

$getStatus = "SELECT count(*) as count from Groupdetails where uemail='".$uemail."' and groupname='".$ugroupname."'";


if ($conn->connect_error) {
   $result = array(
            'title' => $title,
    'msg' => "error"
);
echo stripslashes(json_encode($result));
} 
else
{
	$result = $conn->query($getStatus);
	$row = $result->fetch_assoc();
	
	$finalresult = array(
            'title' => $title,
    'msg' => $row["count"]
);
	
	echo stripslashes(json_encode($finalresult));
 

    
}



$conn->close();
?>