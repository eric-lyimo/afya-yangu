import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/features/authentication/controllers/user.controller.dart';
import 'package:mtmeru_afya_yangu/nav.bar.dart';
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
    bool isLoading = false;

  final db = UserController(); // Your DatabaseHelper instance
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
  setState(() {
      isLoading = true;
  });

  final controller = UserController();
  final response = await controller.loginUser(phone: phone, password:password,context: context);
  if (response['success']==true) {
        setState(() {
      isLoading = false; 
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AfyaBottomNavBar()),
    );
  } else {
      setState(() {
      isLoading = false;
    });
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
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Gradient with Wave
            Stack(
              children: [
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    height: 300,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF2981b3), Color(0xFF073b4c)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  top: 100,
                  left: 22,
                  child: Text(
                    "Habari 👋\nKaribu Tena!",
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            // Login Form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (loginAttempt)
                      const Text(
                        "Umekosea namba ya mtumiaji au neno la siri",
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    const SizedBox(height: 15),

                    // Phone Input
                    TextFormField(
                      controller: username,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Namba ya simu lazima itolewe";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.phone, color: Color(0xFF2981b3)),
                        labelText: 'Namba ya Simu',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Password Input
                    TextFormField(
                      controller: password,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Neno la siri lazima litolewe";
                        }
                        return null;
                      },
                      obscureText: isVisible,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock, color: Color(0xFF2981b3)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isVisible ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() => isVisible = !isVisible);
                          },
                        ),
                        labelText: 'Neno la Siri',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Remember Me + Forgot Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              onChanged: (value) {
                                setState(() => rememberMe = value ?? false);
                              },
                            ),
                            const Text("Kumbuka Neno la Siri"),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: forgot password flow
                          },
                          child: const Text(
                            "Umesahau?",
                            style: TextStyle(color: Color(0xFF2981b3)),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // Login Button
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor: const Color(0xFF2981b3),
                          foregroundColor: Colors.white,
                          elevation: 3,
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                           _login(context, username.text, password.text, rememberMe);
                          }
                        },
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                "INGIA",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Register Prompt
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // TODO: navigate to register
                        },
                        child: const Text.rich(
                          TextSpan(
                            text: "Huna akaunti? ",
                            style: TextStyle(color: Colors.black87),
                            children: [
                              TextSpan(
                                text: "Jisajili",
                                style: TextStyle(
                                  color: Color(0xFF2981b3),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  
}
/// 🎨 Wave Clipper for Header
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()..lineTo(0, size.height - 60);
    final firstControlPoint = Offset(size.width / 4, size.height);
    final firstEndPoint = Offset(size.width / 2, size.height - 60);

    final secondControlPoint = Offset(3 * size.width / 4, size.height - 120);
    final secondEndPoint = Offset(size.width, size.height - 60);

    path
      ..quadraticBezierTo(
          firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy)
      ..quadraticBezierTo(
          secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy)
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}