import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import 'constants.dart';

class NeumorphicPie extends StatelessWidget {
  Map<String, double> dataMap;
  final List<Color> colorList = [red, green];
  bool selectedValue;

  NeumorphicPie({Key key, this.dataMap, this.selectedValue = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      PieChart(
        chartType: ChartType.ring,
        dataMap: dataMap,
        colorList: colorList,
        animationDuration: Duration(milliseconds: 500),
        chartRadius: MediaQuery.of(context).size.width / 2.0,
        showLegends: false,
        decimalPlaces: 1,
        showChartValueLabel: false,
        initialAngle: 0.0,
        chartValueStyle: defaultChartValueStyle.copyWith(
          color: Colors.transparent,
        ),
      ),
      Center(
          child: Container(
        margin: const EdgeInsets.only(top: 10),
        height: MediaQuery.of(context).size.width / 2.0,
        width: MediaQuery.of(context).size.width / 2.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            selectedValue
                ? Text("I think yes",
                    style: TextStyle(
                      color: red,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ))
                : Text("I think no",
                    style: TextStyle(
                      color: green,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(dataMap['Yes'].toInt().toString(),
                    style: TextStyle(
                      color: red,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    )),
                Text("/",
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    )),
                Text(dataMap['No'].toInt().toString(),
                    style: TextStyle(
                      color: green,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    )),
              ],
            ),
          ],
        ),
      )),
    ]);
  }
}
