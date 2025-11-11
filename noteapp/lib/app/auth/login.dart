import 'package:flutter/material.dart';
import 'package:noteapp/components/crud.dart';
import 'package:noteapp/components/customtextform.dart';
import 'package:noteapp/components/valid.dart';
import 'package:noteapp/constant/linkapi.dart';
import 'package:noteapp/main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isLoading = false;

  Crud curd = Crud();

  signIn() async {
    if (formstate.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});

        var response = await curd.postRequest(linkSignIn, {
          "email": email.text,
          "password": password.text,
        });

        isLoading = false;
        setState(() {});

        print("Response: $response"); // 🔍 اطبع الرد للتdebug

        if (response['status'] == 'success') {
          prefs.setString("id", response["data"]["id"].toString());
          //ما الهم لزوم!
          prefs.setString("email", response["data"]["email"]);
          prefs.setString("password", response["data"]["password"]);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("تم التسجيل بنجاح!"),
              backgroundColor: Colors.green,
            ),
          );
          print("Login Success - Navigating to home");
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil("home", (route) => false);
        } else {
          String errorMessage =
              response?['message'] ??
              "كلمة المرور أو البريد الالكتروني خطأ أو الحساب غير موجود!";
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
          );
          print("SignIn Fail - Response: $response");
          // عرض رسالة خطأ للمستخدم
        }
      } catch (e) {
        print("Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error : $e"), backgroundColor: Colors.red),
        );
        isLoading = false;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.grey),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formstate,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset(
                          "images/notes2.png",
                          height: 200,
                          width: 300,
                        ),
                      ),
                      CustTextFormSign(
                        valid: (value) {
                          return validInput(value!, 3, 100);
                        },
                        hint: "email",
                        mycontroller: email,
                      ),
                      CustTextFormSign(
                        valid: (value) {
                          return validInput(value!, 3, 100);
                        },
                        hint: "password",
                        mycontroller: password,
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          await signIn();
                          //Navigator.of(context).pushNamed("home");
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(300, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: Color.fromARGB(255, 135, 197, 248),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),

                      SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed("signup");
                        },
                        child: Text("SignUp"),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
