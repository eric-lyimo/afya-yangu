import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/features/authentication/controllers/user.controller.dart';
import 'package:mtmeru_afya_yangu/features/authentication/models/user.model.dart';
import 'package:mtmeru_afya_yangu/features/authentication/screen/register.screen.dart';
import 'package:mtmeru_afya_yangu/features/home/screen/home.screen.dart';
import 'package:mtmeru_afya_yangu/providers/user.provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool isVisible = true;
  bool loginAttempt = false;
  bool rememberMe = false;

  final db = DatabaseHelper(); // Your DatabaseHelper instance
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool savedRememberMe = prefs.getBool('rememberMe') ?? false;

    if (savedRememberMe) {
      setState(() {
        rememberMe = savedRememberMe;
      });
    }
  }


void _login(BuildContext context, String phone, String password, bool rememberMe) async {
  final dbHelper = DatabaseHelper();

  final userData = await dbHelper.loginUser(phone, password);
  if (userData != null) {
    final user = Users(
      name: userData[DatabaseHelper.columnName],
      email: userData[DatabaseHelper.columnEmail],
      phone: userData[DatabaseHelper.columnPhone],
      dob: userData[DatabaseHelper.columnDob]??"",
      gender: userData[DatabaseHelper.columnGender]??'',
      title: userData[DatabaseHelper.columnTitle]??"", password: '', 
      userId: userData[DatabaseHelper.columnUserId],
    );

    Provider.of<UserProvider>(context, listen: false).setUser(user);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invalid credentials')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.width,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xFF2981b3),
                Color(0xFF073b4c),
              ]),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                'Hello\nSign in!',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (loginAttempt)
                        const Text(
                          "Incorrect phone or password",
                          style: TextStyle(color: Colors.red),
                        ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: username,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "phone is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.check, color: Colors.grey),
                          label: Text(
                            'Phone',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2981b3),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: password,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password must be provided";
                          }
                          return null;
                        },
                        obscureText: isVisible,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              isVisible ? Icons.visibility_off : Icons.visibility,
                            ),
                            color: Colors.grey,
                            onPressed: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                          ),
                          label: const Text(
                            'Password',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2981b3),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: rememberMe,
                            onChanged: (value) {
                              setState(() {
                                rememberMe = value ?? false;
                              });
                            },
                          ),
                          const Text(
                            "Remember Me",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            _login(context, username.text, password.text, rememberMe);
                          }
                        },
                        child: Container(
                          height: 55,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(colors: [
                              Color(0xFF2981b3),
                              Color(0xFF073b4c),
                            ]),
                          ),
                          child: const Center(
                            child: Text(
                              'SIGN IN',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 150),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (builder) => const RegisterScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Register",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
