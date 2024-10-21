import 'package:flutter/material.dart';
import 'package:freeing/common/const/colors.dart';

class ExpansionTileBox extends StatefulWidget {
  String text;
  double width;
  List lists;
  ExpansionTileBox(
      {Key? key, required this.text, required this.width, required this.lists})
      : super(key: key);

  @override
  _ExpansionTileBoxState createState() => _ExpansionTileBoxState();
}

class _ExpansionTileBoxState extends State<ExpansionTileBox> {
  ListView listsWidget() {
    return ListView.builder(
      itemCount: widget.lists.length,
      itemBuilder: (BuildContext context, index) {
        return ListTile(
            title: GestureDetector(
          onTap: () {
            // You can write your own code here.
          },
          child: Text(
            widget.lists[index],
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    var size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: Colors.black)),
        child: Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: ExpansionTile(
            title: Container(
              decoration: BoxDecoration(
                color: LIGHT_IVORY,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(5.0),
              child: Text(
                widget.text,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            children: <Widget>[
              Container(
                height: 150,
                width: screenWidth * 0.9,
                color: Colors.white,
                child: listsWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
