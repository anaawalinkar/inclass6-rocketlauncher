import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rocket Launch Controller',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RocketLaunchController(),
    );
  }
}

class RocketLaunchController extends StatefulWidget {
  @override
  _RocketLaunchControllerState createState() => _RocketLaunchControllerState();
}

class _RocketLaunchControllerState extends State<RocketLaunchController> {
  int _counter = 0;
  bool _isLiftoff = false;

  //increment counter (ignite button)
  void _incrementCounter() {
    setState(() {
      if (_counter < 100) {
        _counter++;
        _checkLiftoff();
      }
    });
  }

  //decrement counter (abort button)
  void _decrementCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--;
        _isLiftoff = false;
      }
    });
  }

  //reset counter button
  void _resetCounter() {
    setState(() {
      _counter = 0;
      _isLiftoff = false;
    });
  }

  //check liftoff condition met
  void _checkLiftoff() {
    if (_counter == 100) {
      setState(() {
        _isLiftoff = true;
      });
      _showLiftoffDialog();
    }
  }

  //liftoff success
  void _showLiftoffDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.rocket_launch, color: Colors.green, size: 30),
              SizedBox(width: 10),
              Text('LIFTOFF SUCCESS!', style: TextStyle(color: Colors.green)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🚀 Rocket has successfully launched!', 
                   style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Image.asset(
                'assets/rocket.gif',
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 10),
              Text('Mission Control: Excellent work, Cadets!', 
                   style: TextStyle(fontStyle: FontStyle.italic)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetCounter();
              },
              child: Text('Start New Mission'),
            ),
          ],
        );
      },
    );
  }

  //color based on counter value
  Color _getCounterColor() {
    if (_counter == 0) {
      return Colors.red;
    } else if (_counter > 50) {
      return Colors.green;
    } else {
      return Colors.orange;
    }
  }

  //status message based on counter val
  String _getStatusMessage() {
    if (_counter == 0) {
      return 'READY FOR LAUNCH SEQUENCE';
    } else if (_counter < 50) {
      return 'FUELING IN PROGRESS';
    } else if (_counter < 100) {
      return 'LAUNCH IMMINENT';
    } else {
      return 'LIFTOFF!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🚀 Rocket Launch Controller'),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[900]!, Colors.black],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //mission status display
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Column(
                children: [
                  Text(
                    _getStatusMessage(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  if (_isLiftoff)
                    Text(
                      '🚀 ROCKET LAUNCHED SUCCESSFULLY! 🚀',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),

            //counter display
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                shape: BoxShape.circle,
                border: Border.all(color: _getCounterColor(), width: 4),
              ),
              child: Text(
                '$_counter%',
                style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                  color: _getCounterColor(),
                ),
              ),
            ),

            //fuel gauge level
            Text(
              'FUEL LEVEL',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            //slider control
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Slider(
                min: 0,
                max: 100,
                value: _counter.toDouble(),
                onChanged: (double value) {
                  setState(() {
                    _counter = value.toInt();
                    _checkLiftoff();
                  });
                },
                activeColor: _getCounterColor(),
                inactiveColor: Colors.grey[600],
                divisions: 100,
                label: '$_counter%',
              ),
            ),

            //button controls
            Container(
              margin: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //abort button
                  ElevatedButton(
                    onPressed: _decrementCounter,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning, color: Colors.white),
                        SizedBox(width: 5),
                        Text('ABORT', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),

                  //ignite button
                  ElevatedButton(
                    onPressed: _incrementCounter,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.rocket_launch, color: Colors.white),
                        SizedBox(width: 5),
                        Text('IGNITE', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),

                  //reset button
                  ElevatedButton(
                    onPressed: _resetCounter,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.refresh, color: Colors.white),
                        SizedBox(width: 5),
                        Text('RESET', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            //progress indicator
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: LinearProgressIndicator(
                value: _counter / 100,
                backgroundColor: Colors.grey[800],
                valueColor: AlwaysStoppedAnimation<Color>(_getCounterColor()),
                minHeight: 10,
                borderRadius: BorderRadius.circular(5),
              ),
            ),

            //instructions
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Use the slider or IGNITE button to fuel the rocket. '
                'Reach 100% for liftoff! ABORT decreases fuel, RESET clears everything.',
                style: TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}