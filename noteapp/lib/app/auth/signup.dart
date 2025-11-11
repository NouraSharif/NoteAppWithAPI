import 'package:flutter/material.dart';
import 'package:noteapp/components/crud.dart';
import 'package:noteapp/components/customtextform.dart';
import 'package:noteapp/components/valid.dart';
import 'package:noteapp/constant/linkapi.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final Crud _crud = Crud();
  bool isLoading = false;
  bool _obscureText = true;

  signUp() async {
    if (formstate.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});

        var response = await _crud.postRequest(linkSignUp, {
          "username": username.text,
          "email": email.text,
          "password": password.text,
        });

        isLoading = false;
        setState(() {});

        if (response['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("تم التسجيل بنجاح!"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil("home", (route) => false);
        } else {
          String errorMessage = response?['message'] ?? "فشل في التسجيل";
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
          );
          print("SignUp Fail: $errorMessage");
        }
      } catch (e) {
        isLoading = false;
        setState(() {});
        print("Error==$e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("حدث خطأ في الاتصال: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text("إنشاء حساب جديد"),
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formstate,
                  child: ListView(
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
                          return validInput(value!, 3, 15);
                        },
                        hint: "اسم المستخدم",
                        mycontroller: username,
                      ),
                      SizedBox(height: 16),
                      CustTextFormSign(
                        valid: (value) {
                          // استخدم الدالة الجديدة للتحقق من البريد الإلكتروني
                          if (value == null || value.isEmpty) {
                            return 'البريد الإلكتروني مطلوب';
                          }

                          // تحقق من صحة البريد الإلكتروني
                          final emailRegex = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                          );
                          if (!emailRegex.hasMatch(value)) {
                            return 'أدخل بريد إلكتروني صحيح';
                          }

                          return null;
                        },
                        hint: "البريد الإلكتروني",
                        mycontroller: email,
                        textInputType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 16),
                      CustTextFormSign(
                        valid: (value) {
                          return validInput(value!, 3, 15);
                        },
                        hint: "كلمة المرور",
                        mycontroller: password,
                        obscureText: _obscureText,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () async {
                          await signUp();
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: Color.fromARGB(255, 135, 197, 248),
                        ),
                        child: Text(
                          "إنشاء حساب",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("لديك حساب بالفعل؟"),
                          SizedBox(width: 8),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("login");
                            },
                            child: Text(
                              "تسجيل الدخول",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
