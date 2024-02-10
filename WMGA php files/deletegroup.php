

<?php


$parameter = $_SERVER['QUERY_STRING'];


$uemail = $_POST['uname'];
$ugroupname = $_POST['gname'];


$servername = "localhost";
$username = "root";
$password = "";
$dbname = "WMGA";
$title = "Delete status";
$message = "1";   // Success =1; Failure = 0;

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection
$deletegrpdetails = "DELETE from Groupdetails where uemail='".$uemail."' and groupname='".$ugroupname."'";
$deletestatus = "DELETE from GroupMemberdetails where groupname='".$ugroupname."'";


if ($conn->connect_error) {
   $result = array(
            'title' => $title,
    'msg' => "0"
);
echo stripslashes(json_encode($result));
} 
else
{
	if($conn ->query($deletegrpdetails))
	{
	$conn->query($deletestatus);
	 $result = array(
            'title' => $title,
    'msg' => $message
);
	}
	else
	{ $result = array(
            'title' => $title,
    'msg' => "0"
);}
	
	
   
echo stripslashes(json_encode($result));
    
}



$conn->close();
?>