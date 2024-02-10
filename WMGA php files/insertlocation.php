<?php


$parameter = $_SERVER['QUERY_STRING'];

$uemail = $_POST['uname'];
$ulatitude = $_POST['ulatitude'];
$ulongitude = $_POST['ulongitude'];


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
	$update = "UPDATE Logindetails set latitude='".$ulatitude."', longitude='".$ulongitude."' where uemail='".$uemail."'";

$conn -> query($update);
				$result = array(
            		'title' => $title,
    				'msg' => $message
					);
			echo stripslashes(json_encode($result));

}

$conn->close();
?>