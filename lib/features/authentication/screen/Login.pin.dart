import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/nav.bar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinLoginScreen extends StatefulWidget {
  const PinLoginScreen({super.key});

  @override
  State<PinLoginScreen> createState() => _PinLoginScreenState();
}

class _PinLoginScreenState extends State<PinLoginScreen>
    with SingleTickerProviderStateMixin {
  final _pinController = TextEditingController();
  final storage = const FlutterSecureStorage();

  late AnimationController _shakeController;
  late Animation<double> _offsetAnimation;

  double _opacity = 0.0;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _offsetAnimation = Tween(begin: 0.0, end: 24.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<String?> getPin() async {
    return await storage.read(key: 'user_pin');
  }

  void _loginWithPin(String pin) async {
    final storedPin = await getPin();
    if (storedPin == pin) {
      setState(() {
        _isSuccess = true;
      });
      await Future.delayed(const Duration(milliseconds: 600));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AfyaBottomNavBar()));
    } else {
      _shakeController.forward(from: 0);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN si sahihi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          // Top wavy shape
          ClipPath(
            clipper: TopWaveClipper(),
            child: Container(
              height: 250,
              color: const Color(0xFF2981B3),
            ),
          ),

          // Greeting text positioned inside the top header
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

          SafeArea(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 800),
              opacity: _opacity,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      const SizedBox(height: 160),
                      const Icon(
                        Icons.health_and_safety,
                        color:  Color(0xFF2981B3),
                        size: 80,
                      ),

                      // Shakeable PIN card with background shape
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Decorative background shape
                          ClipPath(
                            clipper: CardBackgroundClipper(),
                            child: Container(
                              height: 220,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.shade50,
                                    Colors.blue.shade100
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                          ),

                          AnimatedBuilder(
                            animation: _offsetAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(_offsetAnimation.value, 0),
                                child: child,
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 5,
                              shadowColor: Colors.grey.shade300,
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  children: [
                                    const Text(
                                      'Ingiza PIN yako',
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 20),
                                    Stack(
                                      alignment: Alignment.centerRight,
                                      children: [
                                        PinCodeTextField(
                                          controller: _pinController,
                                          appContext: context,
                                          length: 4,
                                          obscureText: true,
                                          keyboardType: TextInputType.number,
                                          animationType: AnimationType.fade,
                                          pinTheme: PinTheme(
                                            shape: PinCodeFieldShape.box,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            fieldHeight: 60,
                                            fieldWidth: 60,
                                            activeFillColor: Colors.white,
                                            inactiveFillColor:
                                                Colors.grey.shade100,
                                            selectedFillColor: Colors.white,
                                            activeColor: _isSuccess
                                                ? Colors.green
                                                : const Color(0xFF2981B3),
                                            selectedColor: _isSuccess
                                                ? Colors.green
                                                : const Color(0xFF2981B3),
                                            inactiveColor: Colors.grey.shade400,
                                          ),
                                          enableActiveFill: true,
                                          onChanged: (_) {},
                                          onCompleted: _loginWithPin,
                                        ),
                                        if (_isSuccess)
                                          const Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: 32,
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    TextButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Tafadhali ingia na nambari ya simu na password ili kuweka PIN mpya.'),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Umesahau PIN?',
                                        style: TextStyle(
                                            color: Color(0xFF2981B3),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
  }
}

/// Top wave clipper
class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60);

    var firstControl = Offset(size.width / 4, size.height);
    var firstEnd = Offset(size.width / 2, size.height - 60);
    path.quadraticBezierTo(firstControl.dx, firstControl.dy, firstEnd.dx, firstEnd.dy);

    var secondControl = Offset(3 * size.width / 4, size.height - 120);
    var secondEnd = Offset(size.width, size.height - 60);
    path.quadraticBezierTo(secondControl.dx, secondControl.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// Decorative card background clipper
class CardBackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(
        size.width * 0.5, 0, size.width, size.height * 0.3);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
