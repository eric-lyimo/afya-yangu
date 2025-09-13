import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/features/authentication/components/form.fields.dart';
import 'package:mtmeru_afya_yangu/features/authentication/controllers/user.controller.dart';
import 'package:mtmeru_afya_yangu/features/authentication/screen/Login.screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final phone = TextEditingController();
  final name = TextEditingController();
  final password = TextEditingController();
  final confirmpassword = TextEditingController();
  final dob = TextEditingController();
  final gender = TextEditingController();
  final title = TextEditingController();

  final UserController controller = UserController();

  var isVisible = true;
  final formKey = GlobalKey<FormState>();
  var isLoading = false;

  final List<String> genderOptions = ["Male", "Female"];
  final List<String> titleOptions = ["Mr", "Mrs", "Dr", "Prof"];

  Future<void> registerUser(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> response = await controller.registerUser(
      name: name.text,
      title: title.text,
      phone: phone.text,
      password: password.text,
      confirmpassword: confirmpassword.text,
      dob: dob.text,
      gender: gender.text,
    );

    setState(() {
      isLoading = false;
    });

    if (response['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User registered successfully! Login to continue'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
          backgroundColor: Colors.red,
        ),
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
              gradient: LinearGradient(
                colors: [
                  Color(0xFF2981b3),
                  Color(0xFF073b4c),
                ],
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                'Create Your\nAccount',
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
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextFormField(
                            controller: name,
                            label: 'Full Name',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Full name cannot be empty";
                              }
                              return null;
                            },
                          ),
                          CustomTextFormField(
                            controller: phone,
                            label: 'Phone',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Phone cannot be empty";
                              }
                              return null;
                            },
                          ),
                          CustomTextFormField(
                            controller: title,
                            label: 'Title',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Title cannot be empty";
                              }
                              return null;
                            },
                            dropdownItems: titleOptions,
                            onChanged: (value) {
                              setState(() {
                                title.text = value!;
                              });
                            },
                          ),
                          CustomTextFormField(
                            controller: password,
                            label: 'Password',
                            obscureText: isVisible,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Password cannot be empty";
                              }
                              return null;
                            },
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isVisible = !isVisible;
                                });
                              },
                              icon: Icon(
                                isVisible ? Icons.visibility_off : Icons.visibility,
                              ),
                            ),
                          ),
                          CustomTextFormField(
                            controller: confirmpassword,
                            label: 'Confirm Password',
                            obscureText: isVisible,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Confirm Password cannot be empty";
                              } else if (password.text != confirmpassword.text) {
                                return "Passwords do not match";
                              }
                              return null;
                            },
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isVisible = !isVisible;
                                });
                              },
                              icon: Icon(
                                isVisible ? Icons.visibility_off : Icons.visibility,
                              ),
                            ),
                          ),
                          CustomTextFormField(
                            controller: dob,
                            label: 'Date of Birth',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Date of Birth cannot be empty";
                              }
                              return null;
                            },
                            isDatePicker: true,
                          ),
                          CustomTextFormField(
                            controller: gender,
                            label: 'Gender',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Gender cannot be empty";
                              }
                              return null;
                            },
                            dropdownItems: genderOptions,
                            onChanged: (value) {
                              setState(() {
                                gender.text = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: isLoading ? null : () => registerUser(context),
                            child: Container(
                              height: 55,
                              width: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF2981b3),
                                    Color(0xFF073b4c),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      )
                                    : const Text(
                                        'SIGN UP',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  "Already have an account?",
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
                                        builder: (context) => const LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
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
