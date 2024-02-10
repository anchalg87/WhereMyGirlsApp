<?php


$parameter = $_SERVER['QUERY_STRING'];

$uemail = $_POST['uemail'];
$upwd = $_POST['upwd'];




$servername = "localhost";
$username = "root";
$password = "";
$dbname = "WMGA";
$title = "LoginMessage";
$message = "1";   // SUccess =1; Failure = 0; Uname doesnt exists =2; uname and pwd doesnt matches =3;

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection

$check = "SELECT * FROM LoginDetails WHERE uemail= '$uemail'";

if ($conn->connect_error) {
   $result = array(
            'title' => $title,
    'msg' => "0"
);
echo stripslashes(json_encode($result));
} 

if ($conn->query($check) -> num_rows > 0) {

$recordcheck = "SELECT * FROM LoginDetails WHERE uemail= '$uemail' and upwd= '$upwd'";

if ($conn->query($recordcheck) -> num_rows == 1) {
$result = array('title' => $title,
    'msg' => $message
);
echo stripslashes(json_encode($result));
}
else
{
	$result = array('title' => $title,
    'msg' => "3"
);
echo stripslashes(json_encode($result));
}


}

else
{
$result = array('title' => $title,
    'msg' => "2"
);
echo stripslashes(json_encode($result));

}
$conn->close();
?>