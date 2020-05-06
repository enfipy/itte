import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class NeumorphicPie extends StatelessWidget {
  Map<String, double> dataMap;
  final List<Color> colorList = [
    Color(0xFFF06262),
    Color(0xFF5AD959),
  ];
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
        child: Center(
          child: selectedValue
              ? Text("I think yes",
                  style: TextStyle(
                      color: Color(0xFFDC5C5C),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ))
              : Text("I think no",
                  style: TextStyle(
                      color: Color(0xFF5AB359),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ))
        ),
      )),
    ]);
  }
}
