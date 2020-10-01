import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrentTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    if(now.hour<9)
      {
         now = DateTime.parse("1969-07-20 09:00:00Z");
      }
    int tempMin = now.minute+ (10 - now.minute % 10);
    int tempHours = now.hour;
    List<String> slotList = List<String>();

    if (tempMin == 60) {
      tempMin = 00;
      tempHours = tempHours + 1;
    }

    while (tempHours < 21) {
      slotList.add((tempHours.toString()+ " : "+tempMin.toString()));
      tempMin = tempMin + 10;
      if (tempMin == 60) {
        tempMin = 00;

        tempHours = tempHours + 1;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Slot Time'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
              child: Text(
                " Date Time: "+now.toString(),
                textAlign: TextAlign.center,
                style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              )),
          Center(
              child: Text(
               "Time Now " +now.hour.toString()+ " : "+now.minute.toString(),
            textAlign: TextAlign.center,
            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          )),

          new Expanded(
              child: new ListView.builder(
                  itemCount: slotList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Text(slotList[index]);
                  }))
        ],
      ),
    );
  }
}
