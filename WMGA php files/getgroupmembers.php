<?php


$parameter = $_SERVER['QUERY_STRING'];


$gname = $_POST['ugname'];

//$gname = "sritejagrp";

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "WMGA";
$title = "MembersMessage";
$message = "1";   // Success =1; Failure = 0;
$allmem = "All Members";
// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection

$getmemnames = "SELECT uemail FROM GroupMemberdetails where groupname ='".$gname."' and status = 1";


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
//    $result = $result + array($allmem);
   
    
echo stripslashes(json_encode($result));
    
}



$conn->close();
?>