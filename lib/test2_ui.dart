import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

class Test2Ui extends StatelessWidget {
  List l = ["9", "10"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: Container(
        height: 100,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 5, offset: Offset(0, 2))
        ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  "April 23, 2022",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            )
            // Timeline.tileBuilder(
            //   builder: TimelineTileBuilder.connectedFromStyle(
            //     contentsBuilder: (context, index) => Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Text(l[index]),
            //     ),
            //     connectorStyleBuilder: (context, index) => ConnectorStyle.solidLine,
            //     indicatorStyleBuilder: (context, index) => IndicatorStyle.dot,
            //     firstConnectorStyle: ConnectorStyle.transparent,
            //     lastConnectorStyle: ConnectorStyle.transparent,
            //     itemCount: 2,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
