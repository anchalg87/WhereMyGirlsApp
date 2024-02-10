<?php


$parameter = $_SERVER['QUERY_STRING'];

$uemail = $_POST['uemail'];
$ugroup = $_POST['ugroup'];
$ugrpswd = $_POST['ugrpswd'];


$servername = "localhost";
$username = "root";
$password = "";
$dbname = "WMGA";
$title = "GroupMessage";
$message = "1";   // Success =1; Failure = 0; Gname already exists =2;

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection

$check = "SELECT * FROM Groupdetails WHERE uemail= '$uemail' and groupname= '$ugroup'";

if ($conn->connect_error) {
   $result = array(
            'title' => $title,
    'msg' => "0"
);
echo stripslashes(json_encode($result));
} 

if ($conn->query($check) -> num_rows > 0) {

$result = array('title' => $title,
    'msg' => "2"
);
echo stripslashes(json_encode($result));

}
else
{
	$insert = "INSERT INTO Groupdetails (uemail, groupname, grppassword)
VALUES ('$uemail', '$ugroup', '$ugrpswd')";

		if ($conn->query($insert) === TRUE) {
 		$result = array(
    
            'title' => $title,
    	'msg' => $message
		);
		echo stripslashes(json_encode($result));
		$gminsert = "INSERT INTO GroupMemberdetails (groupname, uemail, status)
VALUES ('$ugroup', '$uemail', 1)";
		$conn -> query($gminsert);
		
		} else
			{
				$result = array(
            		'title' => $title,
    				'msg' => "0"
					);
			echo stripslashes(json_encode($result));
			}

}

$conn->close();
?>