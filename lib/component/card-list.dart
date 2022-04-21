
import 'package:flutter/material.dart';


class CardList extends StatelessWidget {
  final int id;
  final String name;
  final String address;
  final  VoidCallback? onTap;
  const CardList({
    Key? key,
    this.id = 0,
    this.name = 'Item',
    this.address = 'Address',
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          width: 1,
          color: Colors.black54.withOpacity(0.2),
        ))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Text(
                address,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
