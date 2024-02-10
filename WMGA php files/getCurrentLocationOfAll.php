<?php


$parameter = $_SERVER['QUERY_STRING'];

$groupname = $_POST['gname'];
//$groupname = "friend";

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "WMGA";
$title = "All Users Location";
$message = "1";   // Success =1; Failure = 0; 

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection



if ($conn->connect_error) {
   $result = array(
            'title' => $title,
    'msg' => "0"
);
echo stripslashes(json_encode($result));
} 


else
{
	$getEmail = "select uemail from GroupMemberdetails where groupname='".$groupname."' and status=1";

	$result1 = $conn -> query($getEmail);
	$i = 0;
	$finalresult = array();
	 while ($row1 = $result1->fetch_assoc()) {
	   $i++;
	   $getLocation = "select latitude,longitude from Logindetails where uemail='".$row1['uemail']."'";
	   $result2 = $conn ->query($getLocation);
	   $row2 = $result2 -> fetch_assoc();
	   $finalresult = $finalresult + array($i => $row1['uemail'].",".$row2['latitude'].",".$row2['longitude']);

    }
			echo stripslashes(json_encode($finalresult));

}

$conn->close();
?>