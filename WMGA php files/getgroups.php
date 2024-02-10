<?php


$parameter = $_SERVER['QUERY_STRING'];

$uemail = $_POST['uemail'];

//$uemail ="sudheer123@gmail.com";



$servername = "localhost";
$username = "root";
$password = "";
$dbname = "WMGA";
$title = "LoginMessage";
$message = "1";   // SUccess =1; Failure = 0;

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection

$getgroupnames = "SELECT groupname FROM GroupMemberdetails WHERE uemail= '$uemail' and status=1";


if ($conn->connect_error) {
   $result = array(
            'title' => $title,
    'msg' => "0"
);
echo stripslashes(json_encode($result));
} 
else
{
	$result1 = $conn->query($getgroupnames);
	$i = 0;
	$finalresult = array();
	 while ($row1 = $result1->fetch_assoc()) {
	   $i++;
	   
	   $adminornot = "SELECT uemail from Groupdetails where groupname='".$row1['groupname']."'";
	   $result2 = $conn -> query($adminornot);
	   $row2 = $result2 -> fetch_assoc();
	   
	   if($row2['uemail'] == $uemail)
	   {
	   $finalresult = $finalresult + array($i => $row1['groupname'].",admin" );
	   }
	   else
	   {
       $finalresult = $finalresult + array($i => $row1['groupname'].",user");
       }
    }
    
echo stripslashes(json_encode($finalresult));
    
}



$conn->close();
?>