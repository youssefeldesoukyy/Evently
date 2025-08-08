import 'package:evently/ui/utils/app_routes.dart';
import 'package:flutter/material.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<String> images = [
    'assets/images/first_onBoardingLight.png',
    'assets/images/second_onBoardingLight.png',
    'assets/images/third_onBoardingLight.png',
  ];

  void goToNext() {
    if (currentIndex < images.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      Navigator.push(context, AppRoutes.login);
    }
  }

  void goToBack() {
    if (currentIndex > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: images.length,
                onPageChanged: (index) =>
                    setState(() => currentIndex = index),
                itemBuilder: (context, index) {
                  return Image.asset(
                    images[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  );
                },
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  currentIndex > 0
                      ? InkWell(
                    onTap: goToBack,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blue, width: 2),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.blue,
                          size: 20,
                        ),
                      ),
                    ),
                  )
                      : const SizedBox(width: 40),
        
                  Row(
                    children: List.generate(images.length, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentIndex == index
                              ? Colors.black
                              : Colors.grey[400],
                        ),
                      );
                    }),
                  ),
        
                  InkWell(
                    onTap: goToNext,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blue, width: 2),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.blue,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
