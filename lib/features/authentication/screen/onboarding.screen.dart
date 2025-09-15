import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/features/authentication/screen/Login.screen.dart';
import 'package:mtmeru_afya_yangu/features/authentication/screen/register.screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      "image": "assets/images/logo.png",
      "title": "Karibu Mount Meru Afya Yangu",
      "subtitle": "Mshirika wako wa afya kwa huduma bora za matibabu kutoka Hospitali ya Rufaa ya Mkoa Mount Meru",
    },
    {
      "image": "assets/images/booking.png",
      "title": "Weka Miadi",
      "subtitle": "Weka miadi na daktari au kliniki kwa urahisi na haraka ",
    },
    {
      "image": "assets/images/video.png",
      "title": "Tiba kwa Mtandao",
      "subtitle": "Pata ushauri wa daktari kupitia simu yako mahali popote na wakati wowote, ni rahisi na salama",
    },
    {
      "image": "assets/images/medication.png",
      "title": "Simamia Afya Yako",
      "subtitle": "simamia rekodi zako za matibabu, upate vidokezo vya dawa, na ufuatilie maendeleo yako ya kiafya",
    },
  ];

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Top wave
          ClipPath(
            clipper: TopWaveClipper(),
            child: Container(
              height: 250,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2981B3), Color(0xFF07528D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),



          SafeArea(
            child: Column(
              children: [
                // Skip
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: _goToLogin,
                    child: const Text(
                      "Ruka",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _pages.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            _pages[index]["image"]!,
                            height: 220,
                          ),
                          const SizedBox(height: 40),
                          Text(
                            _pages[index]["title"]!,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Text(
                              _pages[index]["subtitle"]!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                // Dots indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _currentPage == index ? 20 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? const Color(0xFF2981B3)
                            : Colors.grey[400],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Buttons
                if (_currentPage == _pages.length - 1)
                  Column(
                    children: [
                      GestureDetector(
                        onTap: _goToLogin,
                        child: Container(
                          height: 55,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: const Color(0xFF2981B3),
                          ),
                          child: const Center(
                            child: Text(
                              "Anza Sasa",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()),
                          );
                        },
                        child: const Text(
                          "Fungua Akaunti",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  )
                else
                  TextButton(
                    onPressed: () {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: const Text(
                      "Inayofuata →",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
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

