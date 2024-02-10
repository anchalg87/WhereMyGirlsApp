<?php


$parameter = $_SERVER['QUERY_STRING'];
$uemail = $_POST['uname'];
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "WMGA";
$title = "UserLocation";
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
	$getLoc = "select latitude,longitude from Logindetails where uemail='".$uemail."'";

	$result1 = $conn -> query($getLoc);
	$i = 0;
	$result = array();
	 while ($row = $result1->fetch_assoc()) {
	   $i++;
	   // $lat = array($i => $row['latitude']);
// 	   $long = $row['longitude'];
// 	   array_push($lat, $long);    
// 	   array_push($result, $lat);
$result = $result + array($i => $row['latitude'] ) + array($i+1 =>$row['longitude']);

    }
			echo stripslashes(json_encode($result));

}

$conn->close();
?>