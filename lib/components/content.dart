import 'package:flutter/material.dart';

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
