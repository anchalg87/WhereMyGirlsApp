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

$getgroupname = "SELECT groupname FROM GroupMemberdetails where uemail ='".$uemail."' and status = 0";


if ($conn->connect_error) {
   $result = array(
            'title' => $title,
    'msg' => "0"
);
echo stripslashes(json_encode($result));
} 
else
{
	$result = $conn->query($getgroupname);
	
	$i = 0;
	$finalresult = array();
	 while ($row = $result->fetch_assoc()) {
	 $i++;
	  $gname = $row ['groupname'];
	  $getadminname = "SELECT uemail from Groupdetails where groupname ='".$gname."'";
      $result1 = $conn->query($getadminname); 
      $row1 = $result1->fetch_assoc();
      $gadminname = $row1['uemail'];
      $finalresult = $finalresult + array($i => $gname.",".$gadminname);
      
    }
    
echo stripslashes(json_encode($finalresult));
    
}



$conn->close();
?>