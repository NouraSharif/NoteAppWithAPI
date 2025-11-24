const String linkServerName = "http://localhost/coursephp";
//const String linkImageServer = "http://localhost/coursephp/upload";
// استخدم image.php بدل المجلد المباشر
const String linkImageServer = "$linkServerName/image.php?name=";
//Auth
const String linkSignUp = "$linkServerName/auth/signup.php";
const String linkSignIn = "$linkServerName/auth/signin.php";

//Notes
const String linkViewNote = "$linkServerName/notes/view.php";
const String linkAddNote = "$linkServerName/notes/add.php";
const String linkEditNote = "$linkServerName/notes/edit.php";
const String linkDeleteNote = "$linkServerName/notes/delete.php";
