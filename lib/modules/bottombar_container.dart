import 'package:flutter/material.dart';

class BottomBarContainer extends StatelessWidget {
  final Color colors;
  final Function ontap;
  final String title;
  final IconData icons;

  const BottomBarContainer(
      {Key key, this.ontap, this.title, this.icons, this.colors})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(0.0),
        width: MediaQuery.of(context).size.width / 5,
        child: Material(
            color: colors,
            child: InkWell(
                onTap: ontap,
                child: Column(children: [
                  Icon(icons, color: Colors.white),
                  SizedBox(height: 4.0),
                  Text(title, style: TextStyle(color: Colors.white))
                ]))));
  }
}
