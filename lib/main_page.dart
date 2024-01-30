import 'package:demovizai/battery_page.dart';
import 'package:demovizai/battery_temp_page.dart';
import 'package:demovizai/load_page.dart';
import 'package:demovizai/map_page.dart';
import 'package:demovizai/motor_temp_page.dart';
import 'package:demovizai/pressure_page.dart';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'package:http/http.dart' as http;

class CircularArcWithAvatar extends StatelessWidget {
  final double imageScale;
  final String imagePath;
  final String label;
  final Widget destinationPage;

  const CircularArcWithAvatar({
    required this.imageScale,
    required this.imagePath,
    required this.label,
    required this.destinationPage,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationPage),
        );
      },
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                imagePath,
                scale: imageScale,
                height: MediaQuery.of(context).size.width * 0.2,
              ),
              Positioned(
                child: Circular_arc(), // Circular animation above the image
              ),
            ],
          ),
          SizedBox(height: 8), // Spacer between image and text
          Text(
            label,
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}

class Circular_arc extends StatefulWidget {
  const Circular_arc({Key? key}) : super(key: key);

  @override
  _Circular_arcState createState() => _Circular_arcState();
}

class _Circular_arcState extends State<Circular_arc> {
  double sweepAngle = 10.0;

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data directly when the widget is created
  }

  void fetchData() async {
    print('Fetching users...');
    const url = 'http://13.127.214.1:3000/api/v1/vid_12347/vehicledata';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final apiKey = json['data'][0]['api_key'] ?? 0;
      setState(() {
        sweepAngle = math.pi * 1.46 * (apiKey / 100);
      });
      print('Users fetched successfully');
    } else {
      print('Failed to fetch users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width *
          0.2, // Adjusted width for visibility
      height: MediaQuery.of(context).size.width *
          0.2, // Adjusted height for visibility
      child: CustomPaint(
        size: Size(100, 100),
        painter: ProgressArc(sweepAngle, Colors.redAccent, true),
      ),
    );
  }
}

class ProgressArc extends CustomPainter {
  double arc;
  Color progressColor;
  bool isBackground;

  ProgressArc(this.arc, this.progressColor, this.isBackground);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = 30.0;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final startAngle = math.pi * 2.77;
    final sweepAngle = arc != null ? arc : math.pi;
    final useCenter = false;

    if (isBackground) {
      final borderColor = Color.fromARGB(255, 235, 235, 235);

      final backgroundPaint = Paint()
        ..color = Color.fromARGB(255, 77, 77, 77)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 6;

      final startAngleBackground = math.pi * 0.94 - (math.pi / 6);
      final sweepAngleBackground = math.pi * 1.46;

      canvas.drawArc(rect, startAngleBackground, sweepAngleBackground,
          useCenter, backgroundPaint);
      canvas.drawArc(
        rect,
        startAngleBackground,
        sweepAngleBackground,
        useCenter,
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 5,
      );
    }

    Color arcColor = (DataHolder.data > 20 && DataHolder.data < 90)
        ? Colors.green
        : Colors.red;

    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..color = arcColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DataHolder {
  static int data = 75; // Set the data value to 75.0 (for example)
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // bool mapFullScreenView = false;
  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data directly when the widget is created
  }

  fetchData() async {
    print('Fetching users...');
    const url = 'http://13.127.214.1:3000/api/v1/vid_12347/vehicledata';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        DataHolder.data = json['data'][0]['battery'] ?? 0;
      });
      print('Users fetched successfully');
    } else {
      print('Failed to fetch users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        appBar: AppBar(title: Text('KDGaugeView Example')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CircularArcWithAvatar(
                imageScale: 0.9,
                imagePath: 'assets/images/Battery.png',
                label: 'Battery',
                destinationPage: BatteryPage(),
              ),
            ),
            SizedBox(height: 20.0), // Add spacing
            MainPage(),
          ],
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool mapFullScreenView = false;

  void handleMapClick() {
    print("This is called ${mapFullScreenView}");
    // mapFullScreenView = !mapFullScreenView;
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    setState(() {
      mapFullScreenView = !mapFullScreenView;
    });
    // });
  }

  void handleMapClick1() {
    print("This is called ${mapFullScreenView}");
    mapFullScreenView = !mapFullScreenView;
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    // setState(() {
    //   mapFullScreenView = !mapFullScreenView;
    // });
    // });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageScale = screenWidth > 600 ? 1.4 : 1.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: handleMapClick,
              child: Container(
                color: Colors.blue,
                height: mapFullScreenView
                    ? MediaQuery.of(context).size.height - 100
                    : 300,
                width: mapFullScreenView ? double.infinity : 200,
                child: MapPage(handleMapClick: handleMapClick1),
              ),
            ),
            // SizedBox(
            //   height: screenWidth * 0.55,
            // ),
            if (!mapFullScreenView) infoContainer(imageScale, screenWidth),
          ],
        ),
      ),
    );
  }

  Column infoContainer(double imageScale, double screenWidth) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularArcWithAvatar(
              imageScale: imageScale,
              imagePath: 'assets/images/Battery.png',
              label: 'Battery',
              destinationPage: BatteryPage(),
            ),
            SizedBox(
              width: screenWidth * 0.09,
            ),
            CircularArcWithAvatar(
              imageScale: imageScale,
              imagePath: 'assets/images/Battery_temp.png',
              label: 'Battery - temp',
              destinationPage: BatteryTemperaturePage(),
            ),
            SizedBox(
              width: screenWidth * 0.09,
            ),
            CircularArcWithAvatar(
              imageScale: imageScale,
              imagePath: 'assets/images/Motor_temp.png',
              label: 'Motor - temp',
              destinationPage: MotorTemperaturePage(),
            ),
          ],
        ),
        SizedBox(
          height: screenWidth * 0.04, // Adjusted height
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularArcWithAvatar(
              imageScale: imageScale,
              imagePath: 'assets/images/Load.png',
              label: 'Load',
              destinationPage: LoadWeightPage(),
            ),
            SizedBox(
              width: screenWidth * 0.1,
            ),
            CircularArcWithAvatar(
              imageScale: imageScale,
              imagePath: 'assets/images/Pressure.png',
              label: 'Pressure',
              destinationPage: PsiPage(),
            ),
          ],
        ),
        SizedBox(height: screenWidth * 0.12),
        Padding(
          padding:
              EdgeInsets.only(left: screenWidth * 0.03), // Adjust left padding
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                    topLeft: Radius.circular(40), // Adjust top left radius
                    bottomLeft:
                        Radius.circular(40), // Adjust bottom left radius
                  ),
                ),
                padding: EdgeInsets.all(15), // Adjust padding as needed
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/home_button.png',
                      scale: imageScale,
                    ),
                    SizedBox(
                      height: screenWidth * 0.05,
                    ),
                    Image.asset(
                      'assets/images/signal_image.png',
                      scale: imageScale,
                    ),
                    SizedBox(
                      height: screenWidth * 0.05,
                    ),
                    Image.asset(
                      'assets/images/profile_image.png',
                      scale: imageScale,
                    ),
                  ],
                ),
              ),
              SizedBox(width: screenWidth * 0.12),
              Image.asset(
                'assets/images/plus_icon.png',
                scale: imageScale,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
