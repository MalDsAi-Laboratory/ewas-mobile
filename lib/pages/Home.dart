import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Carousel Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: CarouselWithSlider(),
            ),
            // Content Section
            Content(),
          ],
        ),
      ),
    );
  }
}

class CarouselWithSlider extends StatefulWidget {
  @override
  _CarouselWithSliderState createState() => _CarouselWithSliderState();
}

class _CarouselWithSliderState extends State<CarouselWithSlider> {
  int _currentIndex = 0;
  final List<List<String>> carouselItems = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
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
                padding: const EdgeInsets.fromLTRB(0, 22, 8, 90),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.grey.withOpacity(0.5),
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

class Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              // Add action for "Sell" button
              print("Sell Button Pressed");
            },
            child: Text('Sell your E-waste'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(200, 50),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Add action for "View E-Waste Around You" button
              print("View E-Waste Button Pressed");
            },
            child: Text('View E-Waste Around You'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(200, 50),
            ),
          ),
        ],
      ),
    );
  }
}
