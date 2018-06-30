<!doctype html>
<html lang=en>
<head>
    <meta charset=utf-8>
    <title>mysql test</title>
</head>
<body>
<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);

echo "1";
$servername = "localhost";
$username = "root";
$password = "vagrant";

echo "2";
// Create connection

$conn = mysqli_connect($servername, $username, $password);
echo "3";

// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}
echo "<br />Connected successfully";

?>

<hr />

<?php
$servername = "localhost";
$username = "root";
$password = "vagrant";

// Create connection
$conn = new mysqli($servername, $username, $password);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
echo "Connected successfully";
?>
</body>
</html>
