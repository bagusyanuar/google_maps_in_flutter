import 'package:flutter/material.dart';

class PageLoading extends StatelessWidget {
  final String text;
  const PageLoading({Key? key, this.text = 'Sedang Mengunduh Data'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 30,
            width: 30,
            margin: EdgeInsets.only(bottom: 5),
            child: CircularProgressIndicator(color: Colors.brown),
          ),
          Text(text)
        ],
      ),
    );
  }
}