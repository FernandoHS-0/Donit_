import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:donit/pages/Home.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget buildPage({
    required String urlImage,
    required String pageText,
  }) =>
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: [
              const Color(0xFFE0EAFC),
              const Color(0xFFCFDEF3),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              urlImage,
              fit: BoxFit.cover,
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 64),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                pageText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      );

  Widget build(BuildContext context) => Scaffold(
        body: Container(
          padding: const EdgeInsets.only(bottom: 80),
          child: PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() => isLastPage = index == 2);
            },
            children: [
              buildPage(
                urlImage: 'assets/donita.png',
                pageText: 'Accede a tus listas haciendo tap en una de ellas',
              ),
              buildPage(
                urlImage: 'assets/donita2.png',
                pageText:
                    'Desplazate entre listas haciendo swipe dentro de ellas',
              ),
              buildPage(
                urlImage: 'assets/donita3.png',
                pageText: 'Regresa a todas tus listas pellizcando la pantalla',
              ),
            ],
          ),
        ),
        bottomSheet: isLastPage
            ? TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  primary: Colors.white,
                  backgroundColor: const Color(0xFF649FF8),
                  minimumSize: const Size.fromHeight(80),
                ),
                child: const Text('Finalizar'),
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool('showHome', true);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                    colors: [
                      const Color(0xFFE0EAFC),
                      const Color(0xFFCFDEF3),
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        primary: Colors.white,
                        backgroundColor: const Color(0xFF649FF8),
                        padding: const EdgeInsets.all(20),
                      ),
                      child: const Text("Anterior"),
                      onPressed: () => controller.previousPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut),
                    ),
                    Center(
                      child: SmoothPageIndicator(
                        controller: controller,
                        count: 3,
                        effect: ScaleEffect(dotColor: Colors.blue, spacing: 14),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        primary: Colors.white,
                        backgroundColor: const Color(0xFF649FF8),
                        padding: const EdgeInsets.all(20),
                      ),
                      child: const Text("Siguiente"),
                      onPressed: () => controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut),
                    ),
                  ],
                ),
              ),
      );
}
