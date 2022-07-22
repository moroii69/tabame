import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/keys.dart';

class TimeWidget extends StatelessWidget {
  const TimeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, String>>(
      initialData: <String, String>{
        "time": DateFormat('hh:mm:ss').format(DateTime.now()),
        "date": DateFormat('dd MMM').format(DateTime.now()),
        "day": DateFormat('EE').format(DateTime.now()),
      },
      stream: Stream<Map<String, String>>.periodic(const Duration(milliseconds: 500), (int timer) {
        final DateTime now = DateTime.now();
        return <String, String>{
          "time": DateFormat('hh:mm:ss').format(now),
          "date": DateFormat('dd MMM').format(now),
          "day": DateFormat('EE').format(now),
        };
      }),
      builder: (BuildContext context, AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {
        return Container(
          width: 60,
          child: InkWell(
            onTap: () {
              WinKeys.send("{#LWIN}C");
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 0, maxWidth: 100),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // verticalDirection: VerticalDirection.down,
                  children: <Widget>[
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        (snapshot.data as Map<String, String>)["time"] as String,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text("${snapshot.data!["day"]} ${snapshot.data!["date"]}", style: const TextStyle(fontSize: 10)),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}