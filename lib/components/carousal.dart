// carousel_with_slider.dart

import 'package:flutter/material.dart';

class CarouselWithSlider extends StatefulWidget {
  @override
  _CarouselWithSliderState createState() => _CarouselWithSliderState();
}

class _CarouselWithSliderState extends State<CarouselWithSlider> {
  int _currentIndex = 0;
  final List<List<String>> carouselItems = [
    ["assets/images/image.png", 
    'assets/images/image.png', 
    "3", 
    "4", 
    "5", 
    "6", 
    "7", 
    "8", 
    "9", 
    "10"],
    ["SEC 2", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
    ["SEC 3", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            itemCount: carouselItems.length,
            controller: PageController(viewportFraction: 0.9),
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 22, 8, 60),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 158, 158, 158)
                            .withValues(
                                red: 0, green: 0, blue: 255, alpha: 128),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: GridView.builder(
                    padding: EdgeInsets.all(9),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: carouselItems[index].length,
                    itemBuilder: (context, subIndex) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            carouselItems[index][subIndex],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            carouselItems.length,
            (index) => Container(
              width: 8,
              height: 8,
              margin: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index ? Colors.blueAccent : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
