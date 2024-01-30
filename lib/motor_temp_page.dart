import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'main_page.dart'; // Import your main_page.dart file

void main() {
  runApp(MotorTemperaturePage());
}

class MotorTemperaturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Battery Percentage'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<BatteryData> _chartData = [];
  TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);
  bool isImageActive = true;

  @override
  void initState() {
    _chartData = getBatteryData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    double spacerHeight = screenHeight * 0.02;

    double batteryPercentageFontSize = screenWidth * 0.13;
    double batteryTextFontSize = screenWidth * 0.07;
    double vehicleIDFontSize = screenWidth * 0.04;
    double activeImageScale = screenWidth * 0.23; // Adjusted the image scale
    double dateTextFontSize = screenWidth * 0.04;
    double chartPaddingHorizontal = screenWidth * 0.05;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // Spacer before the first row
            SizedBox(height: spacerHeight * 12),

            // First row
            Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: screenWidth * 0.02),
                    // Original active image
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MainPage()),
                        );
                      },
                      child: Image.asset(
                        'assets/images/back.png',
                        width: activeImageScale, // Set the width of the image
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    // Column containing Battery and Vehicle ID texts
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Battery text
                        Text(
                          'Motor',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: batteryTextFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Vehicle ID text
                        Text(
                          'Vehicle ID',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: vehicleIDFontSize,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(102, 102, 102, 1),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: screenWidth * 0.04,
                    ), // Adjust the spacing as needed
                    // Battery percentage text
                    Row(
                      children: [
                        Text(
                          '24',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: batteryPercentageFontSize,
                            fontWeight: FontWeight.bold,
                            color: isImageActive
                                ? Color.fromRGBO(236, 186, 29, 1)
                                : Colors.black,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.002),
                        Text(
                          '°C',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: dateTextFontSize,
                            fontWeight: FontWeight.bold,
                            color: isImageActive
                                ? Color.fromARGB(255, 90, 90, 90)
                                : Color.fromRGBO(18, 18, 18, 1),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: screenWidth * 0.02,
                      height: screenHeight * 0.0001,
                    ),
                    // Active text
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: isImageActive,
                          child: GestureDetector(
                            // Wrap the image with GestureDetector
                            onTap: () {
                              // Handle the tap event
                              setState(() {
                                isImageActive = !isImageActive;
                              });
                            },
                            child: Image.asset(
                              'assets/images/active.png',
                              width:
                                  activeImageScale, // Set the width of the image
                            ),
                          ),
                        ),
                        // Replacement image
                        Visibility(
                          visible: !isImageActive,
                          child: GestureDetector(
                            // Wrap the image with GestureDetector
                            onTap: () {
                              // Handle the tap event
                              setState(() {
                                isImageActive = !isImageActive;
                              });
                            },
                            child: Image.asset(
                              'assets/images/inactive.png',
                              width:
                                  activeImageScale, // Set the width of the image
                            ),
                          ),
                        ),
                        SizedBox(height: 1), // Adjust the spacing as needed
                        Text(
                          isImageActive ? 'Now' : '1 min ago',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: dateTextFontSize,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(85, 85, 85, 1)),
                        ),
                      ],
                    ),
                    // Adjust the spacing as needed
                    // Active image
                  ],
                ),
              ],
            ),

            // Spacer between rows
            SizedBox(height: spacerHeight * 2),

            // Second row
            Container(
              child: Row(
                children: [
                  SizedBox(width: screenWidth * 0.036),
                  Image.asset('assets/images/24h.png'),
                  SizedBox(width: screenWidth * 0.02),
                  Image.asset('assets/images/1m.png'),
                  SizedBox(width: screenWidth * 0.02),
                  Image.asset('assets/images/7d.png'),
                  SizedBox(width: screenWidth * 0.02),
                  Image.asset('assets/images/custom.png'),
                ],
              ),
            ),

            // Spacer between the second row and the chart
            SizedBox(height: spacerHeight),

            // Chart
            Padding(
              padding: EdgeInsets.symmetric(horizontal: chartPaddingHorizontal),
              child: Container(
                height: screenHeight * 0.5,
                child: SfCartesianChart(
                  title: ChartTitle(text: 'Motor Temperature'),
                  legend: Legend(isVisible: true),
                  tooltipBehavior: _tooltipBehavior,
                  primaryXAxis: DateTimeAxis(
                    title: AxisTitle(text: 'Date'),
                    majorGridLines:
                        MajorGridLines(width: 0.5, color: Colors.grey),
                    dateFormat: DateFormat.MMMd(), // Display only month and day
                  ),
                  primaryYAxis: NumericAxis(
                    title: AxisTitle(text: 'Motor Temperature(°C)'),
                    minimum: 0,
                    maximum: 100,
                    interval: 20,
                    majorGridLines:
                        MajorGridLines(width: 0.5, color: Colors.grey),
                  ),
                  series: <LineSeries<BatteryData, DateTime>>[
                    LineSeries<BatteryData, DateTime>(
                      name: 'Motor_Temperature',
                      dataSource: _chartData,
                      xValueMapper: (BatteryData data, _) => data.date,
                      yValueMapper: (BatteryData data, _) => data.percentage,
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                      enableTooltip: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BatteryData> getBatteryData() {
    final List<BatteryData> chartData = [
      BatteryData(DateTime(2017, 5, 6), 80),
      BatteryData(DateTime(2018, 5, 7), 40),
      BatteryData(DateTime(2019, 5, 8), 60),
      BatteryData(DateTime(2020, 5, 9), 50),
      BatteryData(DateTime(2021, 5, 10), 40),
    ];
    return chartData;
  }
}

class BatteryData {
  BatteryData(this.date, this.percentage);
  final DateTime date;
  final double percentage;
}
